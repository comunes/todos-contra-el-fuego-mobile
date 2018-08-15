import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';

import 'colors.dart';
import 'generated/i18n.dart';
import 'genericMap.dart';
import 'globalFiresBottomStats.dart';
import 'locationUtils.dart';
import 'mainDrawer.dart';
import 'models/appState.dart';
import 'placesAutocompleteUtils.dart';
import 'redux/actions.dart';
import 'firesSpinner.dart';

@immutable
class _ViewModel {
  final List<YourLocation> yourLocations;
  final AddYourLocationFunction onAdd;
  final DeleteYourLocationFunction onDelete;
  final ToggleSubscriptionFunction onToggleSubs;
  final OnLocationTapFunction onTap;
  final OnRefreshYourLocationsFunction onRefresh;
  final bool isLoading;

  _ViewModel(
      {@required this.onAdd,
      @required this.onDelete,
      @required this.onToggleSubs,
      @required this.onTap,
      @required this.onRefresh,
      @required this.yourLocations,
      @required this.isLoading});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          yourLocations == other.yourLocations &&
          isLoading == other.isLoading;

  @override
  int get hashCode => yourLocations.hashCode ^ isLoading.hashCode;
}

class ActiveFiresPage extends StatefulWidget {
  static const String routeName = '/fires';

  @override
  _ActiveFiresPageState createState() => _ActiveFiresPageState();
}

class _ActiveFiresPageState extends State<ActiveFiresPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<FabMiniMenuItem> _fabMiniMenuItemList(
      BuildContext context, AddYourLocationFunction onAdd) {
    return [
      new FabMiniMenuItem.withText(
        new Icon(Icons.location_searching),
        fires600,
        8.0,
        S.of(context).addYourCurrentPosition,
        () {
          onAddYourLocation(onAdd);
        },
        S.of(context).addYourCurrentPosition,
        Colors.black38,
        Colors.white,
      ),
      new FabMiniMenuItem.withText(new Icon(Icons.edit_location), fires600, 8.0,
          S.of(context).addSomePlace, () {
        onAddOtherLocation(onAdd);
      }, S.of(context).addSomePlace, Colors.black38, Colors.white)
    ];
  }

  Widget _buildRow(BuildContext context, YourLocation loc, onToggle, onTap) {
    final fireStatsStyle = new TextStyle(color: fires600);
    return new ListTile(
        dense: true,
        isThreeLine: false,
        // leading: const Icon(Icons.location_on),
        trailing: new IconButton(
            icon: new Icon(loc.subscribed
                ? Icons.notifications_active
                : Icons.notifications_off),
            onPressed: () {
              loc.subscribed = !loc.subscribed;
              onToggle(loc);
              setState(() {});
              showSnackMsg(loc.subscribed?  S.of(context).subscribedToFires: S.of(context).unsubscribedToFires);
            }),
        title: new Text(loc.description, style: new TextStyle(fontSize: 16.0)),
        subtitle: loc.currentNumFires == YourLocation.withoutStats
            ? null
            : loc.currentNumFires == 0
                ? new Text(S.of(context).noFiresAround)
                : loc.currentNumFires == 1
                    ? new Text(S
                        .of(context)
                        .fireAroundThisArea(loc.distance.toString()), style: fireStatsStyle)
                    : new Text(S.of(context).firesAroundThisArea(
                        loc.currentNumFires.toString(),
                        loc.distance.toString()), style: fireStatsStyle),
        onLongPress: () {
          showSnackMsg(S.of(context).toDeleteThisPlace);
        },
        onTap: () {
          onTap(loc);
        });
  }

  void showSnackMsg(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  Widget _buildSavedLocations(
      BuildContext context, List<YourLocation> yl, onDeleted, onToggle, onTap) {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: yl.length,
        itemBuilder: (BuildContext _context, int i) {
          final ThemeData theme = Theme.of(context);
          return new Dismissible(
              key: new ObjectKey(yl.elementAt(i)),
              direction: DismissDirection.horizontal,
              onDismissed: (DismissDirection direction) {
                onDeleted(yl.elementAt(i));
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
                          bottom: new BorderSide(color: theme.dividerColor))),
                  child: _buildRow(context, yl.elementAt(i), onToggle, onTap)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) {
          print('New ViewModel of Active Fires');
          return new _ViewModel(
              onAdd: (loc) {
                if (store.state.yourLocations
                    .any((l) => loc.lat == l.lat && loc.lon == l.lon)) {
                  // Already added
                  showSnackMsg(S.of(context).addedThisLocation);
                } else {
                  store.dispatch(new AddYourLocationAction(loc));
                  new Timer(new Duration(milliseconds: 1000), () {
                    gotoLocationMap(store, loc, context);
                  });
                }
              },
              onDelete: (loc) {
                store.dispatch(new DeleteYourLocationAction(loc));
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text(S.of(context).youDeletedThisPlace),
                    action: new SnackBarAction(
                        label: S.of(context).UNDO,
                        onPressed: () {
                          store.dispatch(new AddYourLocationAction(loc));
                        })));
              },
              onToggleSubs: (loc) {
                store.dispatch(new ToggleSubscriptionAction(loc));
              },
              onTap: (loc) {
                gotoLocationMap(store, loc, context);
              },
              onRefresh: (refreshCallback) =>
                  store.dispatch(new FetchYourLocationsAction(refreshCallback)),
              yourLocations: store.state.yourLocations,
              isLoading: !store.state.isLoaded);
        },
        builder: (context, view) {
          var hasLocations = view.yourLocations.length > 0;
          final title = hasLocations
              ? S.of(context).firesInYourPlaces
              : S.of(context).firesInTheWorld;
          print('Building Active Fires');

          return Scaffold(
            key: _scaffoldKey,
            // FIXME new?
            drawer: new MainDrawer(context, ActiveFiresPage.routeName),
            appBar: new AppBar(
              title: Text(title),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            bottomNavigationBar: new GlobalFiresBottomStats(),
            body: view.isLoading
                ? new FiresSpinner()
                : hasLocations
                    ? new Stack(children: <Widget>[
                        new RefreshIndicator(
                            child: _buildSavedLocations(
                                context,
                                view.yourLocations,
                                view.onDelete,
                                view.onToggleSubs,
                                view.onTap),
                            onRefresh: () async {
                              final Completer<Null> completer =
                                  new Completer<Null>();
                              view.onRefresh(completer);
                              return completer.future;
                            }),
                        new FabDialer(_fabMiniMenuItemList(context, view.onAdd),
                            fires600, new Icon(Icons.add))
                      ])
                    : new Center(
                        child: new CenteredColumn(children: <Widget>[
                        new RoundedBtn(
                            icon: Icons.location_searching,
                            text: S.of(context).addYourCurrentPosition,
                            onPressed: () => onAddYourLocation(view.onAdd),
                            backColor: fires600),
                        const SizedBox(height: 26.0),
                        new RoundedBtn(
                            icon: Icons.edit_location,
                            text: S.of(context).addSomePlace,
                            onPressed: () => onAddOtherLocation(view.onAdd),
                            backColor: fires600),
                      ])),
          );
        });
  }

  void gotoLocationMap(
      Store<AppState> store, YourLocation loc, BuildContext context) {
    store.dispatch(new ShowYourLocationMapAction(loc));
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new genericMap()));
  }

  void onAddYourLocation(AddYourLocationFunction onAdd) {
    Future<YourLocation> location = getUserLocation(_scaffoldKey);
    _saveLocation(location, onAdd);
  }

  void onAddOtherLocation(AddYourLocationFunction onAdd) {
    Future<YourLocation> location = openPlacesDialog(_scaffoldKey);
    _saveLocation(location, onAdd);
  }

  void _saveLocation(Future<YourLocation> location, onAdd) {
    location.then((newLocation) {
      if (newLocation != YourLocation.noLocation) {
        onAdd(newLocation);
      }
    });
  }
}
