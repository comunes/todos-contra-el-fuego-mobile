import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/i18n.dart';
import 'mainDrawer.dart';

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
      child: new OutlineButton.icon(
        icon: const Icon(Icons.favorite_border),
        label: new Text(S.of(context).comunesSupportBtn),
        onPressed: () {
          launch("https://comunes.org/");
        },
      ),
    );
  }

  Widget buildShareButton() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new OutlineButton.icon(
        icon: const Icon(Icons.share),
        label: new Text(S.of(context).shareAppBtn),
        onPressed: () {
          launch(
              "https://play.google.com/store/apps/details?id=org.comunes.fires");
        },
      ),
    );
  }

  Widget buildStarButton() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new OutlineButton.icon(
        icon: const Icon(Icons.star_border),
        label: new Text(S.of(context).starAppBtn),
        onPressed: () {
          LaunchReview.launch();
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
        drawer: new MainDrawer(context, SupportPage.routeName),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new CenteredColumn(children: <Widget>[
            new Flexible(
                child: new CenteredColumn(children: <Widget>[
              new Text(
                S.of(context).supportPageDescription,
                textAlign: TextAlign.center,
              ),
              new SizedBox(height: 20.0),
              buildSupportButton(),
              new SizedBox(height: 20.0),
              buildStarButton(),
              new SizedBox(height: 20.0),
              buildShareButton()
            ]))
          ]),
        ));
  }
}
