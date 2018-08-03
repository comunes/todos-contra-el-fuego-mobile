import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';

import 'activeFires.dart';
import 'fireAlert.dart';
import 'colors.dart';
import 'generated/i18n.dart';
import 'mainDrawer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _homeFont = const TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.w600,
    // color: Colors.white,
  );
    final _btnFont = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    // color: Colors.white,
  );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer.getDrawer(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FloatingActionButton.extended(
            elevation: 0.0,
            onPressed: () {
               Navigator.pushNamed(context, ActiveFiresPage.routeName);
            },
            label: Text(S.of(context).activeFires, style: _btnFont),
            backgroundColor: fires600,
            heroTag: 'activeFires',
            icon: const Icon(Icons.whatshot, size: 32.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 26.0),
            child: FloatingActionButton.extended(
              elevation: 0.0,
              onPressed: () {
                Navigator.pushNamed(context, FireAlert.routeName);
              },
              heroTag: 'notifyFire',
              backgroundColor: fires600,
              label: new Text(S.of(context).notifyAFire, style: _btnFont),
              icon: const Icon(Icons.notifications_active, size: 32.0),
            ),
          ),
        ]),
        body: new SafeArea(
          child: Center(
              child: new CenteredColumn(children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      icon: new Icon(Icons.menu,
                          size: 30.0, color: Colors.black38)),
                ]),
            new Expanded(
                child: new FractionallySizedBox(
                    alignment: FractionalOffset.center,
                    heightFactor: 0.7,
                    child: new Image.asset('images/logo-200.png',
                        fit: BoxFit.fitHeight))),
            new Expanded(
                child: new FractionallySizedBox(
                    alignment: FractionalOffset.topCenter,
                    heightFactor: 1.0,
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: FittedBox(
                              child: new Text(S.of(context).appName,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,

                                  style: _homeFont),
                              fit: BoxFit.scaleDown,
                            )),
                      ],
                    )))
          ])),
        ));
  }
}
