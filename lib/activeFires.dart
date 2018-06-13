import 'package:flutter/material.dart';
import 'mainDrawer.dart';
import 'genericMap.dart';
import 'dart:async';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'colors.dart';
import 'placesAutocompleteUtils.dart';
import 'basicLocation.dart';
import 'locationUtils.dart';
import 'globals.dart' as globals;
import 'basicLocationPersist.dart';
import 'globalFiresBottomStats.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class ActiveFiresPage extends StatefulWidget {
  static const String routeName = '/fires';

  ActiveFiresPage();

  @override
  _ActiveFiresPageState createState() => _ActiveFiresPageState();
}

class _ActiveFiresPageState extends State<ActiveFiresPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<FabMiniMenuItem> _fabMiniMenuItemList(BuildContext context) {
    return [
      new FabMiniMenuItem.withText(
        new Icon(Icons.location_searching),
        fires600,
        8.0,
        "Add your current position",
        () {
          onAddYourLocation();
        },
        "Add your current position",
        Colors.black38,
        Colors.white,
      ),
      new FabMiniMenuItem.withText(
          new Icon(Icons.edit_location), fires600, 8.0, "Add some other place",
          () {
        onAddOtherLocation(context);
      }, "Add some other place", Colors.black38, Colors.white)
    ];
  }

  _ActiveFiresPageState();

  Widget _buildRow(BasicLocation loc) {
    return new ListTile(
        dense: true,
        leading: const Icon(Icons.location_on),
        trailing: new IconButton(
            icon: new Icon(loc.isSubscribed
                ? Icons.notifications_active
                : Icons.notifications_off),
            onPressed: () {
              loc.subscribed = !loc.isSubscribed;
              persistYourLocations();
              setState(() {});
            }),
        title: new Text(loc.description),
        onLongPress: () {
          showSnackMsg('Slide horizontally to delete this location');
        },
        onTap: () {
          showLocationMap(loc);
        });
  }

  void showLocationMap(BasicLocation loc) {
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
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          /* if (i.isOdd) {
          return new Divider();
        } */

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of saved items
          // in the ListView, minus the divider widgets.
          // final int index = i ~/ 2;
          // print('$i $index');
          // if (index >= _saved.length) return null;
          return _buildItem(globals.yourLocations.elementAt(i));
        });
  }

  void handleUndo(BasicLocation item) {
    setState(() {
      globals.yourLocations.add(item);
      persistYourLocations();
    });
  }

  Widget _buildItem(BasicLocation item) {
    final ThemeData theme = Theme.of(context);
    return new Dismissible(
        key: new ObjectKey(item),
        direction: DismissDirection.horizontal,
        onDismissed: (DismissDirection direction) {
          setState(() {
            globals.yourLocations.remove(item);
            persistYourLocations();
          });
          final String action = 'deleted';
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text('You $action this position'),
              action: new SnackBarAction(
                  label: 'UNDO',
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
        ? 'Active fires in your places'
        : 'Active fires in the world';
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
                  _fabMiniMenuItemList(context), fires600, new Icon(Icons.add))
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
                  text: 'Fires near other place',
                  onPressed: () {
                    onAddOtherLocation(context);
                  },
                  backColor: fires600),
            ])),
      floatingActionButton: hasLocations
          ? Column(mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  /* FloatingActionButton.extended(
                    onPressed: onAddYourLocation,
                    heroTag: 'yourposition',
                    label: const Text('Add your position'),
                    icon: const Icon(Icons.location_searching),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        onAddOtherLocation(context);
                      },
                      heroTag: 'otherplace',
                      label: new Text('Add some other place'),
                      icon: const Icon(Icons.edit_location),
                    ),
                  ), */
                ])
          : null,
    );
  }

  void onAddYourLocation() {
    Future<BasicLocation> location = getUserLocation(_scaffoldKey);
    _saveLocation(location);
  }

  void onAddOtherLocation(BuildContext context) {
    Future<BasicLocation> location = openPlacesDialog(context);
    _saveLocation(location);
  }

  void _saveLocation(Future<BasicLocation> location) {
    location.then((newLocation) {
      if (newLocation != BasicLocation.noLocation) {
        if (globals.yourLocations.contains(newLocation)) {
          showSnackMsg('You have already added this location');
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
