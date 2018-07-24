import 'package:flutter/material.dart';

import 'colors.dart';
import 'sandbox.dart';
import 'activeFires.dart';
import 'globals.dart' as globals;
import 'generated/i18n.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'privacyPage.dart';
import 'fireAlert.dart';
import 'supportPage.dart';

class MainDrawer extends Drawer {
  MainDrawer(BuildContext context, {key})
      : super(key: key, child: mainDrawer(context));
}

Widget mainDrawer(BuildContext context) {
  return new ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: listWithoutNulls(<Widget>[
      new GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/');
        },
        child: new DrawerHeader(
          child: new Column(
            children: <Widget>[
              new Image.asset(
                'images/logo-200.png',
                fit: BoxFit.scaleDown,
                height: 80.0,
              ),
              const SizedBox(height: 20.0),
              new Text(S.of(context).appName,
                  style: new TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
            ],
          ),
          decoration: new BoxDecoration(
            color: fires300,
          ),
        ),
      ),
      new ListTile(
        leading: const Icon(Icons.whatshot),
        title: new Text(S.of(context).activeFires),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, ActiveFiresPage.routeName);
        },
      ),
      new ListTile(
        leading: const Icon(Icons.notifications_active),
        title: new Text(S.of(context).notifyAFire),
        onTap: () {
          // Then close the drawer
          Navigator.pop(context);
          Navigator.pushNamed(context, FireAlert.routeName);
        },
      ),
      new Divider(),
      new ListTile(
        leading: const Icon(Icons.favorite),
        title: new Text(S.of(context).supportThisInitiative),
        onTap: () {
          // Then close the drawer
          Navigator.pop(context);
          Navigator.pushNamed(context, SupportPage.routeName);
        },
      ),
      new ListTile(
        leading: const Icon(Icons.lock),
        title: new Text(S.of(context).privacyPolicy),
        onTap: () {
          // Then close the drawer
          Navigator.pop(context);
          Navigator.pushNamed(context, PrivacyPage.routeName);
        },
      ),
      globals.isDevelopment ?
      new ListTile(
        leading: const Icon(Icons.bug_report),
        title: new Text('Sandbox'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, Sandbox.routeName);
        },
      ): null,
      new AboutListTile(
        icon: globals.appIcon,
        applicationName: S.of(context).appName,
        applicationVersion: globals.appVersion,
        applicationIcon: globals.appMediumIcon,
        applicationLegalese: S.of(context).appLicense(DateTime.now().year.toString()),
        aboutBoxChildren: <Widget> [
          // new Text('What?')
        ]
        // FIXME
      )
    ])
  );
}
