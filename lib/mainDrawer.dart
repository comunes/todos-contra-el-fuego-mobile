import 'package:badge/badge.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'activeFires.dart';
import 'colors.dart';
import 'fireAlert.dart';
import 'fireNotificationList.dart';
import 'generated/i18n.dart';
import 'globals.dart' as globals;
import 'models/appState.dart';
import 'privacyPage.dart';
import 'sandbox.dart';
import 'supportPage.dart';

@immutable
class _ViewModel {
  final int unreadCount;

  _ViewModel({
    @required this.unreadCount,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _ViewModel &&
            runtimeType == other.runtimeType &&
            unreadCount == other.unreadCount;
  }

  @override
  int get hashCode => unreadCount.hashCode;
}

class MainDrawer extends Drawer {
  MainDrawer(BuildContext context, {key})
      : super(key: key, child: mainDrawer(context));

  static getDrawer(BuildContext context) {
    Injector inj = Injector.getInjector();
    MainDrawer d;
    try {
      d = inj.get<MainDrawer>();
    } catch (e) {
      inj.map<MainDrawer>((i) => new MainDrawer(context), isSingleton: true);
      d = inj.get<MainDrawer>();
    }
    return d;
  }
}

Widget mainDrawer(BuildContext context) {
  return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) {
        return new _ViewModel(unreadCount: store.state.fireNotificationsUnread);
      },
      builder: (context, view) {
        final bottomTextStyle = new TextStyle(fontSize: 12.0, color: Colors.grey);
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
              new ListTile(
                leading: const Icon(Icons.notifications),
                title: view.unreadCount > 0
                    ? Badge.after(
                        spacing: 5.0,
                        borderColor: Colors.red,
                        child: Text(S.of(context).fireNotificationsTitleShort),
                        value: ' ${view.unreadCount.toString()} ')
                    : Text(S.of(context).fireNotificationsTitleShort),
                onTap: () {
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.pushNamed(context, FireNotificationList.routeName);
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
              globals.isDevelopment
                  ? new ListTile(
                      leading: const Icon(Icons.bug_report),
                      title: new Text('Sandbox'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Sandbox.routeName);
                      },
                    )
                  : null,
              new AboutListTile(
                  icon: globals.appIcon,
                  applicationName: S.of(context).appName,
                  applicationVersion: globals.appVersion,
                  applicationIcon: globals.appMediumIcon,
                  applicationLegalese: S.of(context).appLicense(DateTime.now().year.toString()),
                  aboutBoxChildren: <Widget>[
                    new SizedBox(height: 10.0),
                    new Text(S.of(context).appMoto), // , style: new TextStyle(fontStyle: FontStyle.italic)),
                    new SizedBox(height: 10.0),
                    new Text(S.of(context).NASAAck, style: bottomTextStyle),
                    // More ?
                  ])
            ]));
      });
}
