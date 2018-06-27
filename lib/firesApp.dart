import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'activeFires.dart';
import 'generated/i18n.dart';
import 'homePage.dart';
import 'introPage.dart';
import 'sandbox.dart';
import 'theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'models/appState.dart';

class FiresApp extends StatelessWidget {
  static final WidgetBuilder introWidget = (context) => new IntroPage();
  static final WidgetBuilder continueWidget = (context) => new HomePage();

  final Map routes = <String, WidgetBuilder>{
    IntroPage.routeName: introWidget,
    HomePage.routeName: continueWidget,
    ActiveFiresPage.routeName: (BuildContext context) => new ActiveFiresPage(),
    Sandbox.routeName: (BuildContext context) => new Sandbox(),
  };

  final Store<AppState> store;

  // globals.getIt.registerSingleton
  FiresApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(store: this.store, child:
      new MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback:
            S.delegate.resolution(fallback: new Locale("en", "")),
        home: new MaterialAppWithIntroHome(
            introWidget, continueWidget, 'showInitialWizard-2018-06-27-01'),
        onGenerateTitle: (context) => S.of(context).appName,
        theme: firesTheme,
        routes: routes));
  }
}
