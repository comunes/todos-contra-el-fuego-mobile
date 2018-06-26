import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
import 'generated/i18n.dart';

class IntroPage extends AppIntroPage {
  static const String routeName = '/intro';

  static final fireItems = (context) =>
    <AppIntroItem>[
      AppIntroItem(icon: Icons.location_on, title: S.of(context).chooseAPlace),
      AppIntroItem(
        icon: Icons.panorama_fish_eye, title: S.of(context).chooseAWatchRadio),
      AppIntroItem(
        icon: Icons.whatshot, title: S.of(context).getAlertsOfFiresinThatArea),
      AppIntroItem(
        icon: Icons.notifications_active,
        title: S.of(context).alertWhenThereIsAFire)
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
