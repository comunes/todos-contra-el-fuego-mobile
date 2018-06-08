import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';

class IntroPage extends AppIntroPage {
  static const String routeName = '/intro';

  static final List<AppIntroItem> fireItems = <AppIntroItem>[
    AppIntroItem(icon: Icons.location_on, title: 'Choose a place'),
    AppIntroItem(icon: Icons.panorama_fish_eye, title: 'Choose a watch radio'),
    AppIntroItem(
        icon: Icons.whatshot, title: 'Get alerts of fires in that area'),
    AppIntroItem(
        icon: Icons.notifications_active, title: 'Alert when there is a fire'),
  ];

  /*
  static final OnIntroFinish onFinish =
      (context) => Navigator.pushNamed(context, '/?'); */

  IntroPage({Key key})
      : super(
            items: fireItems,
            onIntroFinish: (context) =>
                Navigator.pushNamed(context, HomePage.routeName),
            key: key);
}
