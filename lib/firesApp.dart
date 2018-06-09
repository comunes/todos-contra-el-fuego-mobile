import 'package:flutter/material.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'homePage.dart';
import 'theme.dart';
import 'introPage.dart';
import 'sandbox.dart';
import 'activeFires.dart';
import 'placesAutocompleteWidget.dart';
import 'globals.dart' as globals;

class FiresApp extends StatelessWidget {


  Map routes = <String, WidgetBuilder>{
        PlacesAutocompleteWidget.routeName: (BuildContext context) =>
            new PlacesAutocompleteWidget(),
        Sandbox.routeName: (BuildContext context) => new Sandbox(),
        ActiveFiresPage.routeName: (BuildContext context) =>
            new ActiveFiresPage(),
        IntroPage.routeName: (BuildContext context) => new IntroPage(),
      };
  final WidgetBuilder introWidget = (context) => new IntroPage();
  final WidgetBuilder continueWidget = (context) => new HomePage();

  // globals.getIt.registerSingleton
  FiresApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new MaterialAppWithIntroHome(introWidget, continueWidget),
        title: 'All Against The Fire!',
        theme: firesTheme,
        routes: routes);
  }
}
