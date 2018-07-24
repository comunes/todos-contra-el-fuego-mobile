import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/i18n.dart';

class SupportPage extends StatefulWidget {
  static const String routeName = '/support';

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget buildSupportButton() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new FloatingActionButton(
        heroTag: 'callAction',
        child: const Icon(Icons.favorite),
        onPressed: () {
          launch("https://comunes.org/");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar:
            new AppBar(title: new Text(S.of(context).supportThisInitiative)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new CenteredColumn(children: <Widget>[
            new Flexible(
                child: new CenteredColumn(children: <Widget>[
              new Text(S.of(context).supportPageDescription, textAlign: TextAlign.center,),
              new SizedBox(height: 20.0),
              buildSupportButton()
            ]))
          ]),
        ));
  }
}
