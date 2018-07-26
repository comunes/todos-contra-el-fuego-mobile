import 'package:flutter/material.dart';

/*
Useful for debug
import 'package:fluttery/framing.dart';
new RandomColorBlock( child
*/

class Sandbox extends StatelessWidget {
  static const String routeName = '/sandbox';

  @override
  Widget build(BuildContext context) {
    //showDialog(context: context, child: builder(context));
    return Scaffold(
        appBar: new AppBar(
            title: new TextField(
          autofocus: true,
          controller: new TextEditingController(text: "kk"),
          decoration: new InputDecoration(),
          onSubmitted: (todoText) {},
        )),
        body: new RaisedButton(
            child: new Text('Press'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return new SimpleDialog(
                        title: new Text('title'),
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: new Text('hhh'),
                          ),
                        ]);
                  });
            }));
  }
}
