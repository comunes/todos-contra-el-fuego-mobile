import 'package:community_material_icon/community_material_icon.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'customStepper.dart';

import 'generated/i18n.dart';
import 'placesAutocompleteUtils.dart';

class FireAlert extends StatefulWidget {
  static const String routeName = '/fireAlert';

  @override
  _FireAlertState createState() => _FireAlertState();
}

class _FireAlertState extends State<FireAlert> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentStep = 0;

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

  List<CustomStep> listWithoutNulls(List<CustomStep> children) =>
      children.where(notNull).toList();

  @override
  Widget build(BuildContext context) {
    List<CustomStep> fireSteps = listWithoutNulls(<CustomStep>[
      new CustomStep(
          title: new Text(S.of(context).callEmergencyServicesTitle),
          // subtitle:
          content: new Column(children: <Widget>[
            new Text(S.of(context).callEmergencyServicesDescription),
            new SizedBox(height: 20.0),
            buildCallButton()
          ])),
      // TODO conditional: this only in Spain
      new CustomStep(
          title: new Text(S.of(context).tweetAboutAFireTitle),
          // subtitle: new Text(S.of(context).tweetAboutAFireDescription),
          content: new Column(children: <Widget>[
            new Text(S.of(context).tweetAboutAFireDescription),
            new SizedBox(height: 20.0),
            buildTweetButton()
          ])),
    ]);
    final stepInc = () {
      setState(() {
        if (_currentStep < fireSteps.length - 1) {
          _currentStep += 1;
        } else {
          _currentStep = 0;
        }
      });
    };
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(title: new Text(S.of(context).notifyAFire)),
        body: new CustomStepper(
            currentCustomStep: _currentStep,
            // type: StepperType.horizontal,
            onCustomStepTapped: (num) => setState(() {
                  _currentStep = num;
                }),
            steps: fireSteps));
  }
}
