import 'dart:async';

import 'package:bson_objectid/bson_objectid.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:redux/redux.dart';

import 'firesSpinner.dart';
import 'activeFires.dart';
import 'colors.dart';
import 'fireAlert.dart';
import 'fireNotificationList.dart';
import 'generated/i18n.dart';
import 'mainDrawer.dart';
import 'models/appState.dart';
import 'redux/actions.dart';

class _ViewModel {
  final bool isLoaded;

  _ViewModel({@required this.isLoaded});

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is _ViewModel &&
        runtimeType == other.runtimeType &&
        isLoaded == other.isLoaded;

  @override
  int get hashCode => isLoaded.hashCode;

}

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Store<AppState> store = Injector.getInjector().get<Store<AppState>>();
  final Connectivity _connectivity = new Connectivity();
  final List<FireNotification> newNotifications = [];

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    ConnectivityResult connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = ConnectivityResult.none;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      store.dispatch(new OnConnectivityChanged(connectionStatus));
      if (connectionStatus == ConnectivityResult.none) {
        _showDialog(S.of(context).noConnectivity);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      debugPrint("onMessage in fireApp (isLoaded: ${store.state.isLoaded}): $message");
      _showItemDialog(message, _notifForMessage(message));
    }, onLaunch: (Map<String, dynamic> message) {
      debugPrint("onLaunch (isLoaded: ${store.state.isLoaded}): $message");
      _notifForMessage(message);
      _navigateToItemDetail(message);
    }, onResume: (Map<String, dynamic> message) {
      debugPrint("onResume (isLoaded: ${store.state.isLoaded}): $message");
      _notifForMessage(message);
      _navigateToItemDetail(message);
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // print(token);
      store.dispatch(new OnUserTokenAction(token));
      setState(() {});
    });
    initConnectivity();
    // StreamSubscription<ConnectivityResult> _connectivitySubscription =
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (!mounted) {
        return;
      }
      setState(() {
        store.dispatch(new OnConnectivityChanged(result));
        //   _showDialog(result.toString());
      });
    });
  }

  final _homeFont = const TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.w600,
  );
  final _btnFont = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) {
          bool isLoaded = store.state.isLoaded;
          if (isLoaded && newNotifications.isNotEmpty) {
            newNotifications.forEach((notif) {
              store.dispatch(new AddFireNotificationAction(notif));
            });
            newNotifications.clear();
          }
          return new _ViewModel(
            isLoaded: store.state.isLoaded
          );
        },
        builder: (context, view) {
          return new Scaffold(
              key: _scaffoldKey,
              drawer: new MainDrawer(context, HomePage.routeName),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      elevation: 0.0,
                      onPressed: () {
                        Navigator.pushNamed(context, ActiveFiresPage.routeName);
                      },
                      label: Text(S.of(context).activeFires, style: _btnFont),
                      backgroundColor: fires600,
                      heroTag: 'activeFires',
                      icon: const Icon(Icons.whatshot, size: 32.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 26.0),
                      child: FloatingActionButton.extended(
                        elevation: 0.0,
                        onPressed: () {
                          Navigator.pushNamed(context, FireAlert.routeName);
                        },
                        heroTag: 'notifyFire',
                        backgroundColor: fires600,
                        label: new Text(S.of(context).notifyAFire,
                            style: _btnFont),
                        icon:
                            const Icon(Icons.notifications_active, size: 32.0),
                      ),
                    ),
                  ]),
              body: !view.isLoaded? new FiresSpinner(): new SafeArea(
                child: Center(
                    child: new CenteredColumn(children: <Widget>[
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            icon: new Icon(Icons.menu,
                                size: 30.0, color: Colors.black38)),
                      ]),
                  new Expanded(
                      child: new FractionallySizedBox(
                          alignment: FractionalOffset.center,
                          heightFactor: 0.7,
                          child: new Image.asset('images/logo-200.png',
                              fit: BoxFit.fitHeight))),
                  new Expanded(
                      child: new FractionallySizedBox(
                          alignment: FractionalOffset.topCenter,
                          heightFactor: 1.0,
                          child: new Column(
                            children: <Widget>[
                              new Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: FittedBox(
                                    child: new Text(S.of(context).appName,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: _homeFont),
                                    fit: BoxFit.scaleDown,
                                  )),
                            ],
                          )))
                ])),
              ));
        });
  }

  void _showDialog(String message) {
    showDialog<bool>(
        context: _scaffoldKey.currentContext,
        builder: (_) => new AlertDialog(
              content: new Text(message),
              actions: <Widget>[
                new FlatButton(
                  child: Text(S.of(_scaffoldKey.currentContext).CLOSE),
                  onPressed: () {
                    Navigator.pop(_scaffoldKey.currentContext);
                  },
                ),
              ],
            ));
  }

  void _showItemDialog(Map<String, dynamic> message, FireNotification notif) {
    showDialog<bool>(
      context: _scaffoldKey.currentContext,
      builder: (_) => _buildDialog(_scaffoldKey.currentContext, notif),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
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

  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    Navigator.popUntil(_scaffoldKey.currentContext,
        (Route<dynamic> route) => route is PageRoute);
    /* if (!notif.getRoute(store).isCurrent) {
      // Navigator.push(_scaffoldKey.currentContext, notif.getRoute(store));
    } */
    Navigator.pushNamed(
        _scaffoldKey.currentContext, FireNotificationList.routeName);
  }

  // https://pub.dartlang.org/packages/firebase_messaging#-example-tab-
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FireNotification _notifForMessage(Map<String, dynamic> message) {
    FireNotification notif;
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
      debugPrint(notif.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    if (notif != null)
    newNotifications.add(notif);
    return notif;
  }
}
