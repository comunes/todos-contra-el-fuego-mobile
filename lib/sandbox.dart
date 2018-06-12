import 'package:flutter/material.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'slider.dart';

/*
Useful for debug
import 'package:fluttery/framing.dart';
new RandomColorBlock( child:
*/

class Sandbox extends StatelessWidget {
  static const String routeName = '/sandbox';

  @override
  Widget build(BuildContext context) {
    //showDialog(context: context, child: builder(context));
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) =>
            Stack(fit: StackFit.expand, children: <Widget>[
              // Material(color: Colors.yellowAccent),
              Positioned(
                top: 0.0,
                child: Icon(Icons.star, size: 40.0),
              ),
              Positioned(
                top: constraints.maxHeight - 80,
                right: 10.0,
                left: 10.0,
                child: new CenteredRow(
                  children: <Widget>[new FireDistanceSlider()],
                ),
              )
            ]),
      ),
    );
  }
}
