import 'package:flutter/material.dart';

import 'colors.dart';
import 'sandbox.dart';
import 'introPage.dart';
import 'activeFires.dart';
import 'placesAutocompleteWidget.dart';

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
              new Text('seedees',
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
        // https://docs.flutter.io/flutter/material/CircleAvatar-class.html
        leading: new CircleAvatar(
          backgroundColor: Colors.brown.shade800,
          child: new Text('VR'),
        ),
        title: new Text('Your profile'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          // Navigator.pop(context);
          Navigator.pushNamed(context, IntroPage.routeName);
        },
      ),
      new Divider(),
      new ListTile(
        leading: const Icon(Icons.whatshot),
        title: new Text('Active fires'),
        onTap: () {
          Navigator.pushNamed(context, ActiveFiresPage.routeName);
        },
      ),
      new ListTile(
        leading: const Icon(Icons.location_on),
        title: new Text('My areas'),
        onTap: () {
          // Then close the drawer
          Navigator.pushNamed(context, '/subscriptions');
        },
      ),
      new ListTile(
        leading: const Icon(Icons.location_on),
        title: new Text('Places'),
        onTap: () {
          // Then close the drawer
          Navigator.pushNamed(context, PlacesAutocompleteWidget.routeName);
        },
      ),
      new Divider(),
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
          // FIXME
          )
    ],
  );
}
