import 'package:flutter/material.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'homePage.dart';
import 'theme.dart';
import 'introPage.dart';
import 'sandbox.dart';
import 'activeFires.dart';

class FiresApp extends StatelessWidget {
  final Map routes = <String, WidgetBuilder>{
    Sandbox.routeName: (BuildContext context) => new Sandbox(),
    ActiveFiresMap.routeName: (BuildContext context) => new ActiveFiresMap(),
    IntroPage.routeName: (BuildContext context) => new IntroPage(),
  };
  final WidgetBuilder introWidget = (context) => new IntroPage();
  final WidgetBuilder continueWidget = (context) => new HomePage();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new MaterialAppWithIntroHome(introWidget, continueWidget),
        title: 'All Against The Fire!',
        theme: firesTheme,
        routes: routes);
  }
}
