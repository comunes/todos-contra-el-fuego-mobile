import 'package:flutter/material.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'homePage.dart';
import 'theme.dart';
import 'introPage.dart';
import 'sandbox.dart';
import 'activeFires.dart';

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
        home: new MaterialAppWithIntroHome(introWidget, continueWidget, 'showInitialWizard234'),
        title: 'All Against The Fire!',
        theme: firesTheme,
        routes: routes);
  }
}
