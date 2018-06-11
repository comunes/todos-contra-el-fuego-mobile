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
      body: new CenteredColumn(
        children: <Widget>[
          new FireDistanceSlider()

        ],
      ),
    );
  }
}
