import 'package:flutter/material.dart';

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
      appBar: new AppBar(
          title: new TextField(
        controller: new TextEditingController(text: "kk"),
        decoration: new InputDecoration(),
        onSubmitted: (todoText) {},
      )),
      body: new Text("Sandbox"),
    );
  }
}
-añ