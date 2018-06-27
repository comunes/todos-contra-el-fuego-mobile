import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

import 'colors.dart';
import 'generated/i18n.dart';
import 'genericMap.dart';
import 'globalFiresBottomStats.dart';
import 'globals.dart' as globals;
import 'locationUtils.dart';
import 'mainDrawer.dart';
import 'placesAutocompleteUtils.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:fires_flutter/models/yourLocationPersist.dart';

class ActiveFiresPage extends StatefulWidget {
  static const String routeName = '/fires';

  ActiveFiresPage();

  @override
  _ActiveFiresPageState createState() => _ActiveFiresPageState();
}

class _ActiveFiresPageState extends State<ActiveFiresPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<FabMiniMenuItem> _fabMiniMenuItemList() {
    return [
      new FabMiniMenuItem.withText(
        new Icon(Icons.location_searching),
        fires600,
        8.0,
        S.of(context).addYourCurrentPosition,
        () {
          onAddYourLocation();
        },
        S.of(context).addYourCurrentPosition,
        Colors.black38,
        Colors.white,
      ),
      new FabMiniMenuItem.withText(new Icon(Icons.edit_location), fires600, 8.0,
          S.of(context).addSomePlace, () {
        onAddOtherLocation();
      }, S.of(context).addSomePlace, Colors.black38, Colors.white)
    ];
  }

  _ActiveFiresPageState();

  Widget _buildRow(YourLocation loc) {
    return new ListTile(
        dense: true,
        leading: const Icon(Icons.location_on),
        trailing: new IconButton(
            icon: new Icon(loc.subscribed
                ? Icons.notifications_active
                : Icons.notifications_off),
            onPressed: () {
              loc.subscribed = !loc.subscribed;
              int i = globals.yourLocations.indexOf(loc);
              globals.yourLocations.removeAt(i);
              globals.yourLocations.insert(i, loc);
              persistYourLocations();
              setState(() {});
            }),
        title: new Text(loc.description),
        onLongPress: () {
          showSnackMsg(S.of(context).toDeleteThisPlace);
        },
        onTap: () {
          showLocationMap(loc);
        });
  }

  void showLocationMap(YourLocation loc) {
    // , VoidCallback onSubs
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new GenericMap(
                title: loc.description,
                location: loc,
                operation: MapOperation.view)));
  }

  void showSnackMsg(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  Widget _buildSavedLocations() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: globals.yourLocations.length,
        itemBuilder: (BuildContext _context, int i) {
          return _buildItem(globals.yourLocations.elementAt(i));
        });
  }

  void handleUndo(YourLocation item) {
    setState(() {
      globals.yourLocations.add(item);
      persistYourLocations();
    });
  }

  Widget _buildItem(YourLocation item) {
    final ThemeData theme = Theme.of(context);
    return new Dismissible(
        key: new ObjectKey(item),
        direction: DismissDirection.horizontal,
        onDismissed: (DismissDirection direction) {
          setState(() {
            globals.yourLocations.remove(item);
            persistYourLocations();
          });

          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(S.of(context).youDeletedThisPlace),
              action: new SnackBarAction(
                  label: S.of(context).UNDO,
                  onPressed: () {
                    handleUndo(item);
                  })));
        },
        background: new Container(
            color: theme.primaryColor,
            child: const ListTile(
                leading:
                    const Icon(Icons.delete, color: Colors.white, size: 36.0))),
        secondaryBackground: new Container(
            color: theme.primaryColor,
            child: const ListTile(
                trailing:
                    const Icon(Icons.delete, color: Colors.white, size: 36.0))),
        child: new Container(
            decoration: new BoxDecoration(
                color: theme.canvasColor,
                border: new Border(
                    bottom: new BorderSide(color: theme.dividerColor))),
            child: _buildRow(item)));
  }

  @override
  Widget build(BuildContext context) {
    var hasLocations = globals.yourLocations.length > 0;
    final title = hasLocations
        ? S.of(context).firesInYourPlaces
        : S.of(context).firesInTheWorld;
    print('Building Active Fires');
    return Scaffold(
      key: _scaffoldKey,
      // FIXME new?
      drawer: new MainDrawer(context),
      appBar: new AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: new GlobalFiresBottomStats(),
      body: hasLocations
          ? new Stack(children: <Widget>[
              _buildSavedLocations(),
              new FabDialer(
                  _fabMiniMenuItemList(), fires600, new Icon(Icons.add))
            ])
          : new Center(
              child: new CenteredColumn(children: <Widget>[
              new RoundedBtn(
                  icon: Icons.location_searching,
                  text: 'Fires near your',
                  onPressed: onAddYourLocation,
                  backColor: fires600),
              const SizedBox(height: 26.0),
              new RoundedBtn(
                  icon: Icons.edit_location,
                  text: S.of(context).firesNearPlace,
                  onPressed: onAddOtherLocation,
                  backColor: fires600),
            ])),
    );
  }

  void onAddYourLocation() {
    Future<YourLocation> location = getUserLocation(_scaffoldKey);
    _saveLocation(location);
  }

  void onAddOtherLocation() {
    Future<YourLocation> location = openPlacesDialog(_scaffoldKey);
    _saveLocation(location);
  }

  void _saveLocation(Future<YourLocation> location) {
    location.then((newLocation) {
      if (newLocation != YourLocation.noLocation) {
        if (globals.yourLocations.contains(newLocation)) {
          showSnackMsg(S.of(context).addedThisLocation);
        } else
          this.setState(() {
            globals.yourLocations.add(newLocation);
            persistYourLocations();
            new Timer(new Duration(milliseconds: 1000), () {
              showLocationMap(newLocation);
            });
          });
      }
    });
  }
}
