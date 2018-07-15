import 'package:community_material_icon/community_material_icon.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/i18n.dart';
import 'placesAutocompleteUtils.dart';

class FireAlert extends StatefulWidget {
  static const String routeName = '/fireAlert';

  @override
  _FireAlertState createState() => _FireAlertState();
}

class _FireAlertState extends State<FireAlert> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget buildCallButton() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new FloatingActionButton(
        heroTag: 'callAction',
        child: const Icon(Icons.call),
        onPressed: () {
          launch("tel://112");
        },
      ),
    );
  }

  Widget buildTweetButton() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new FloatingActionButton(
        heroTag: 'tweetAction',
        child: const Icon(CommunityMaterialIcons.twitter),
        onPressed: () {
          // In Android you can choose with app to use with setPackage but seems it's not implemented here
          // https://stackoverflow.com/questions/6814268/android-share-on-facebook-twitter-mail-ecc
          openPlacesDialog(_scaffoldKey).then((yourLocation) {
            String where =
                yourLocation.description.replaceAll(' ', '').split(',')[0];
            print(where);
            Share.share('#IF${where} FIXME');
          }).catchError((onError) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text(
                    S.of(_scaffoldKey.currentContext).errorFirePlaceDialog)));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(title: new Text(S.of(context).notifyAFire)),
        body: new CenteredColumn(
          children: <Widget>[
            new Flexible(
              child: new CenteredColumn(
                children: <Widget>[
                  new Text(S.of(context).callEmergencyServicesDescription,
                      softWrap: true),
                  new Text(S.of(context).tweetAboutAFireDescription),
                ],
              ),
            ),
            buildCallButton(),
            buildTweetButton()
          ],
        ));
  }
}
