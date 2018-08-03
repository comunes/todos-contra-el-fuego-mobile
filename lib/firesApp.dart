
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
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


  // globals.getIt.registerSingleton
  _FiresAppState(this.store);


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
}
