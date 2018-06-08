import 'package:flutter/material.dart';

import 'colors.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'mainDrawer.dart';
import 'activeFires.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  final _btnFont = const TextStyle(
    fontSize: 20.0,
    // fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new MainDrawer(context),
        body: new SafeArea(
          child: Center(
              child: new CenteredColumn(children: <Widget>[
            new Expanded(
                child: new FractionallySizedBox(
                    alignment: FractionalOffset.bottomCenter,
                    heightFactor: 0.8,
                    child: new Image.asset('images/logo-200.png',
                        fit: BoxFit.fitHeight))),
            new Expanded(
                child: new FractionallySizedBox(
                    alignment: FractionalOffset.topCenter,
                    heightFactor: 0.9,
                    child: new CenteredColumn(
                      children: <Widget>[
                        customBtn(
                            Icons.whatshot,
                            "Active fires",
                            context,
                            // const EdgeInsets.only(left: 60.0),
                            ActiveFiresMap.routeName),
                      ],
                    )))
          ])),
        ));
  }

  SizedBox customBtn(IconData icon, String text, BuildContext context, route) {
    final btnRadius = new Radius.circular(90.0);
    return new SizedBox(
      // width: double.infinity,
      child: new RaisedButton(
          elevation: 1.0,
          color: fires600,
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(icon, size: 32.0, color: Colors.white),
                new SizedBox(width: 10.0),
                new Text(text, style: _btnFont),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(btnRadius))),
    );
  }
}
