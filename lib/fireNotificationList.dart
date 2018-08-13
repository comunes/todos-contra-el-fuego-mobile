import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';

import 'customMoment.dart';
import 'generated/i18n.dart';
import 'genericMap.dart';
import 'mainDrawer.dart';
import 'models/appState.dart';
import 'redux/actions.dart';
import 'firesSpinner.dart';

@immutable
class _ViewModel {
  final bool isLoaded;
  final List<FireNotification> fireNotifications;
  final int fireNotificationsUnread;
  final List<YourLocation> yourLocations;
  final TapFireNotificationFunction onTap;
  final DeleteFireNotificationFunction onDelete;
  final DeleteAllFireNotificationFunction onDeleteAll;

  _ViewModel(
      {@required this.isLoaded,
      @required this.onTap,
      @required this.onDelete,
      @required this.onDeleteAll,
      @required this.fireNotifications,
      @required this.yourLocations,
      @required this.fireNotificationsUnread});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          isLoaded == other.isLoaded &&
          fireNotifications == other.fireNotifications &&
          fireNotificationsUnread == other.fireNotificationsUnread &&
          yourLocations == other.yourLocations;

  @override
  int get hashCode =>
      isLoaded.hashCode ^
      fireNotifications.hashCode ^
      fireNotificationsUnread.hashCode ^
      yourLocations.hashCode;
}

class FireNotificationList extends StatefulWidget {
  static const String routeName = '/fireNotifications';

  @override
  _FireNotificationListState createState() => _FireNotificationListState();
}

class _FireNotificationListState extends State<FireNotificationList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildRow(BuildContext context, List<YourLocation> yourLocations,
      FireNotification notif, onDeleted, onTap) {
    String prefix = "";

    if (notif.subsId != null) {
      // FIXME (this can fails if you don't have a location for this notif, for instance during tests)
      YourLocation yl =
          yourLocations.singleWhere((yl) => yl.id == notif.subsId);
      prefix = '${yl.description}. ';
    }

    return new ListTile(
        dense: true,
        leading: const Icon(Icons.whatshot),
        title: new Text('${prefix}${notif.description}',
            style: new TextStyle(
                fontWeight: notif.read ? FontWeight.normal : FontWeight.bold)),
        subtitle: new Text(Moment.now().from(context, notif.when)),
        onLongPress: () {
          showSnackMsg(S.of(context).toDeleteThisNotification);
        },
        onTap: () {
          onTap(notif);
        });
  }

  void showSnackMsg(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  Widget _buildSavedFireNotifications(
      BuildContext context,
      List<YourLocation> yourLocations,
      List<FireNotification> notifList,
      onDeleted,
      onTap) {
    return new RefreshIndicator(
        child: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            // reverse: true,
            // shrinkWrap: true,
            itemCount: notifList.length,
            itemBuilder: (BuildContext _context, int i) {
              final ThemeData theme = Theme.of(context);
              return new Dismissible(
                  key: new ObjectKey(notifList.elementAt(i)),
                  direction: DismissDirection.horizontal,
                  onDismissed: (DismissDirection direction) {
                    onDeleted(notifList.elementAt(i));
                  },
                  background: new Container(
                      color: theme.primaryColor,
                      child: const ListTile(
                          leading: const Icon(Icons.delete,
                              color: Colors.white, size: 36.0))),
                  secondaryBackground: new Container(
                      color: theme.primaryColor,
                      child: const ListTile(
                          trailing: const Icon(Icons.delete,
                              color: Colors.white, size: 36.0))),
                  child: new Container(
                      decoration: new BoxDecoration(
                          color: theme.canvasColor,
                          border: new Border(
                              bottom:
                                  new BorderSide(color: theme.dividerColor))),
                      child: _buildRow(context, yourLocations,
                          notifList.elementAt(i), onDeleted, onTap)));
            }),
        onRefresh: _handleRefresh);
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));

    setState(() {});

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) {
          print('New ViewModel of Fires Notifications (unread: ${store.state
          .fireNotificationsUnread})');
          return new _ViewModel(
              isLoaded: store.state.isLoaded,
              onDeleteAll: () {
                store.dispatch(new DeleteAllFireNotificationAction());
              },
              onDelete: (notif) {
                store.dispatch(new DeleteFireNotificationAction(notif));
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text(S.of(context).youDeletedThisNotification),
                    action: new SnackBarAction(
                        label: S.of(context).UNDO,
                        onPressed: () {
                          store.dispatch(new AddFireNotificationAction(notif));
                        })));
              },
              onTap: (notif) {
                if (!notif.read) {
                  store.dispatch(new ReadFireNotificationAction(
                      notif.copyWith(read: true)));
                }
                new Timer(new Duration(milliseconds: 500), () {
                  gotoMap(store, notif, context);
                });
              },
              yourLocations: store.state.yourLocations,
              fireNotifications: store.state.fireNotifications,
              fireNotificationsUnread: store.state.fireNotificationsUnread);
        },
        builder: (context, view) {
          var hasFireNotifications = view.fireNotifications.length > 0;
          final title = S.of(context).fireNotificationsTitle;
          print('Building Fire Notifications List');

          return Scaffold(
              key: _scaffoldKey,
              drawer: new MainDrawer(context, FireNotificationList.routeName),
              appBar: new AppBar(
                  title: Text(title),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  actions: listWithoutNulls(<Widget>[
                    hasFireNotifications
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _showConfirmDialog(view))
                        : null
                  ])),
              body: !view.isLoaded ? new FiresSpinner() : !hasFireNotifications
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: new Card(
                          child: new Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new CenteredColumn(children: <Widget>[
                                new Icon(Icons.notifications_none,
                                    size: 150.0, color: Colors.black26),
                                new SizedBox(height: 20.0),
                                new Text(
                                    S.of(context).fireNotificationsDescription,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.1,
                                    style: new TextStyle(
                                        height: 1.3, color: Colors.black45))
                              ]))))
                  : _buildSavedFireNotifications(context, view.yourLocations,
                      view.fireNotifications, view.onDelete, view.onTap));
        });
  }

  void gotoMap(
      Store<AppState> store, FireNotification notif, BuildContext context) {
    store.dispatch(new ShowFireNotificationMapAction(notif));
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new genericMap()));
  }

  _showConfirmDialog(_ViewModel view) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(S.of(context).areYouSureTitle),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                    S.of(context).deleteAllFireNotificationsAlertDescription)
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(S.of(context).DELETE),
              onPressed: () {
                view.onDeleteAll();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
