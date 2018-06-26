import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'activeFires.dart';
import 'generated/i18n.dart';
import 'homePage.dart';
import 'introPage.dart';
import 'sandbox.dart';
import 'theme.dart';

class FiresApp extends StatelessWidget {
  static final WidgetBuilder introWidget = (context) => new IntroPage();
  static final WidgetBuilder continueWidget = (context) => new HomePage();

  final Map routes = <String, WidgetBuilder>{
    IntroPage.routeName: introWidget,
    HomePage.routeName: continueWidget,
    ActiveFiresPage.routeName: (BuildContext context) => new ActiveFiresPage(),
    Sandbox.routeName: (BuildContext context) => new Sandbox(),
  };

  // globals.getIt.registerSingleton
  FiresApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback:
            S.delegate.resolution(fallback: new Locale("en", "")),
        home: new MaterialAppWithIntroHome(
            introWidget, continueWidget, 'showInitialWizard234'),
        onGenerateTitle: (context) => S.of(context).appName,
        theme: firesTheme,
        routes: routes);
  }
}
