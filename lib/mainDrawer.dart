import 'package:flutter/material.dart';

import 'colors.dart';
import 'sandbox.dart';
import 'activeFires.dart';
import 'globals.dart' as globals;

class MainDrawer extends Drawer {
  MainDrawer(BuildContext context, {key})
      : super(key: key, child: mainDrawer(context));
}

Widget mainDrawer(BuildContext context) {
  return new ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      new GestureDetector(
        onTap: () {
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
              new Text(globals.appName,
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
      /* new ListTile(
        // https://docs.flutter.io/flutter/material/CircleAvatar-class.html
        leading: new CircleAvatar(
          backgroundColor: Colors.brown.shade800,
          child: new Text('VR'),
        ),
        title: new Text('Your profile'),
        onTap: () {
          Navigator.pushNamed(context, IntroPage.routeName);
        },
      ),
      new Divider(), */
      new ListTile(
        leading: const Icon(Icons.whatshot),
        title: new Text('Active fires'),
        onTap: () {
          Navigator.pushNamed(context, ActiveFiresPage.routeName);
        },
      ),
      new ListTile(
        leading: const Icon(Icons.notifications_active),
        title: new Text('Notify a fire'),
        onTap: () {
          // Then close the drawer
          Navigator.pushNamed(context, Sandbox.routeName);
        },
      ),
      new Divider(),
      new ListTile(
        leading: const Icon(Icons.favorite),
        title: new Text('Support this initiative'),
        onTap: () {
          // Then close the drawer
          Navigator.pushNamed(context, '/subscriptions');
        },
      ),
      new ListTile(
        leading: const Icon(Icons.bug_report),
        title: new Text('Sandbox'),
        onTap: () {
          Navigator.pushNamed(context, Sandbox.routeName);
        },
      ),
      new ListTile(
        // https://material.io/tools/icons/?style=baseline
        leading: const Icon(Icons.settings),
        title: new Text('Settings'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      new AboutListTile(
        icon: globals.appIcon,
        applicationName: globals.appName,
        applicationVersion: globals.appVersion,
        applicationIcon: globals.appMediumIcon,
        applicationLegalese: globals.appLicense,
        aboutBoxChildren: <Widget> [
          // new Text('What?')
        ]
        // FIXME
      )
    ],
  );
}
