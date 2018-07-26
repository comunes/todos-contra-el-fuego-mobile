import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';

import 'customMoment.dart';
import 'generated/i18n.dart';
import 'mainDrawer.dart';
import 'models/appState.dart';
import 'redux/actions.dart';
// import 'fireNotificationMap.dart';

@immutable
class _ViewModel {
  final List<FireNotification> fireNotifications;
  final TapFireNotificationFunction onTap;

  //final OnReceivedFireNotificationFunction onReceived;
  final DeleteFireNotificationFunction onDelete;
  final DeleteAllFireNotificationFunction onDeleteAll;

  _ViewModel(
      {@required this.onTap,
      //      @required this.onReceived,
      @required this.onDelete,
      @required this.onDeleteAll,
      @required this.fireNotifications});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _ViewModel &&
            runtimeType == other.runtimeType &&
            fireNotifications == other.fireNotifications;
  }

  @override
  int get hashCode => fireNotifications.hashCode;
}

class FireNotificationList extends StatefulWidget {
  static const String routeName = '/fireNotifications';

  @override
  _FireNotificationListState createState() => _FireNotificationListState();
}

class _FireNotificationListState extends State<FireNotificationList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildRow(
      BuildContext context, FireNotification notif, onDeleted, onTap) {
    return new ListTile(
        dense: true,
        leading: const Icon(Icons.whatshot),
        title: new Text(notif.description,
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

  Widget _buildSavedFireNotifications(BuildContext context,
      List<FireNotification> notifList, onDeleted, onTap) {
    return new RefreshIndicator(
        child: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            reverse: true,
            shrinkWrap: true,
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
                      child: _buildRow(
                          context, notifList.elementAt(i), onDeleted, onTap)));
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
          print('New ViewModel of Fires Notifications');
          return new _ViewModel(
              onDeleteAll: () {
                store.dispatch(new DeleteAllFireNotificationAction());
              },
              onDelete: (notif) {
                store.dispatch(new DeleteFireNotificationAction(notif));
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text(S.of(context).youDeletedThisPlace),
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
              },
              fireNotifications: store.state.fireNotifications);
        },
        builder: (context, view) {
          var hasFireNotifications = view.fireNotifications.length > 0;
          final title = S.of(context).fireNotificationsTitle;
          print('Building Fire Notifications List');

          return Scaffold(
              key: _scaffoldKey,
              drawer: new MainDrawer(context),
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
              body: !hasFireNotifications
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
                  : _buildSavedFireNotifications(context,
                      view.fireNotifications, view.onDelete, view.onTap));
        });
  }

  void gotoLocationMap(
      Store<AppState> store, FireNotification notif, BuildContext context) {
    /*    store.dispatch(new ShowFireNotificationMapAction(notif));
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new FireNotificationMap())); */
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
