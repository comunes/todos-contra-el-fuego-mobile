import 'package:flutter/material.dart';
import 'mainDrawer.dart';

class ActiveFiresMap extends StatelessWidget {
  static const String routeName = '/fires';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: new MainDrawer(context),
        appBar: new AppBar(
          title: Text('Active fires'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.location_searching), onPressed: () => {}),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('More button');
              },
            ),
          ],
        ),
        body: new Text('No active fires'));
  }
}
