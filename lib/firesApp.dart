import 'dart:async';

import 'package:bson_objectid/bson_objectid.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux/src/store.dart';

import 'activeFires.dart';
import 'fireAlert.dart';
import 'fireNotificationList.dart';
import 'generated/i18n.dart';
import 'homePage.dart';
import 'introPage.dart';
import 'models/appState.dart';
import 'privacyPage.dart';
import 'redux/actions.dart';
import 'sandbox.dart';
import 'supportPage.dart';
import 'theme.dart';

class FiresApp extends StatefulWidget {
  FiresApp(this.store);

  final Store<AppState> store;

  @override
  _FiresAppState createState() => _FiresAppState(store);
}

class _FiresAppState extends State<FiresApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static final WidgetBuilder introWidget = (context) => new IntroPage();
  static final WidgetBuilder continueWidget = (context) => new HomePage();

  final Map routes = <String, WidgetBuilder>{
    IntroPage.routeName: introWidget,
    HomePage.routeName: continueWidget,
    PrivacyPage.routeName: (BuildContext context) => new PrivacyPage(context),
    ActiveFiresPage.routeName: (BuildContext context) => new ActiveFiresPage(),
    Sandbox.routeName: (BuildContext context) => new Sandbox(),
    FireAlert.routeName: (BuildContext context) => new FireAlert(),
    SupportPage.routeName: (BuildContext context) => new SupportPage(),
    FireNotificationList.routeName: (BuildContext context) =>
        new FireNotificationList(),
  };

  final Store<AppState> store;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // globals.getIt.registerSingleton
  _FiresAppState(this.store);

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      // store.dispatch(action);
      _connectionStatus = connectionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    StatefulWidget home = new MaterialAppWithIntroHome(
        introWidget, continueWidget, 'showInitialWizard-2018-06-27-01');
    return new StoreProvider<AppState>(
        store: this.store,
        child: new MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback:
                S.delegate.resolution(fallback: new Locale("en", "")),
            home: home,
            onGenerateTitle: (context) {
              print('MaterialApp onGenerateTitle');
              if (store.state.user.lang == null) {
                String lang = Localizations.localeOf(context).languageCode;
                this.store.dispatch(new OnUserLangAction(lang));
              }
              return S.of(context).appName;
            },
            theme: firesTheme,
            routes: routes));
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      debugPrint("onMessage in fireApp: $message");
      _showItemDialog(message, store);
    }, onLaunch: (Map<String, dynamic> message) {
      debugPrint("onLaunch: $message");
      _navigateToItemDetail(message, store);
    }, onResume: (Map<String, dynamic> message) {
      debugPrint("onResume: $message");
      _navigateToItemDetail(message, store);
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      store.dispatch(new OnUserTokenAction(token));
      setState(() {});
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() => _connectionStatus = result.toString());
    });
  }

  void _showItemDialog(Map<String, dynamic> message, Store store) {
    final notif = _notifForMessage(message);
    showDialog<bool>(
      context: navigatorKey.currentContext,
      builder: (_) => _buildDialog(navigatorKey.currentContext, notif),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message, store);
      }
    }).catchError((e) => print("$e"));
  }

  Widget _buildDialog(BuildContext context, FireNotification item) {
    return new AlertDialog(
      content: new Text(item.description),
      actions: <Widget>[
        new FlatButton(
          child: Text(S.of(context).CLOSE),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: Text(S.of(context).SHOW),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message, Store store) {
    FireNotification notif = _notifForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(navigatorKey.currentContext,
        (Route<dynamic> route) => route is PageRoute);
    if (!notif.getRoute(store).isCurrent) {
      Navigator.push(navigatorKey.currentContext, notif.getRoute(store));
    }
  }

  // https://pub.dartlang.org/packages/firebase_messaging#-example-tab-
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FireNotification _notifForMessage(Map<String, dynamic> message) {
    FireNotification notif;
    // print('start parse notif');
    try {
      notif = new FireNotification(
          id: new ObjectId.fromHexString(message['id']),
          subsId: new ObjectId.fromHexString(message['subsId']),
          lat: double.parse(message['lat']),
          lon: double.parse(message['lon']),
          description: message['description'],
          read: false,
          when: DateTime.parse(message['when']),
          sealed: message['sealed']);
      // print('end parse notif');
      debugPrint(notif.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    if (notif != null) store.dispatch(new AddFireNotificationAction(notif));
    return notif;
  }
}
