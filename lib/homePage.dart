import 'package:flutter/material.dart';

import 'colors.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'mainDrawer.dart';
import 'activeFires.dart';
import 'generated/i18n.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _homeFont = const TextStyle(
    fontSize: 35.0,
    fontWeight: FontWeight.w400,
    // color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: new MainDrawer(context),
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
                    heightFactor: 0.9,
                    child: new CenteredColumn(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text(
                            S.of(context).appName,
                            textAlign: TextAlign.center,
                            softWrap: true, style: _homeFont),
                        ),
                        new SizedBox(height: 20.0),
                        new RoundedBtn.nav(
                            icon: Icons.whatshot,
                            text: S.of(context).activeFires,
                            context: context,
                            route: ActiveFiresPage.routeName,
                            backColor: fires600),
                        new SizedBox(height: 20.0),
                        new RoundedBtn.nav(
                          icon: Icons.notifications_active,
                          text: S.of(context).notifyAFire,
                          context: context,
                          route: ActiveFiresPage.routeName,
                          backColor: fires600),
                      ],
                    )))
          ])),
        ));
  }
}
