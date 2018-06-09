import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'mainDrawer.dart';
import 'genericMap.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'colors.dart';
import 'placesAutocompleteUtils.dart';
import 'basicLocation.dart';
import 'package:collection/collection.dart' show lowerBound;

class _ActiveFiresPageState extends State<ActiveFiresPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // https://docs.flutter.io/flutter/dart-core/List-class.html
  final List<BasicLocation> _saved = [];
  int length;

  _ActiveFiresPageState();

  Widget _buildRow(BasicLocation loc) {
    String desc = loc.description != null
        ? loc.description
        : 'Position: ${loc.lat}, ${loc.lon}';
    return new ListTile(
        dense: false,
        leading: const Icon(Icons.location_on),
        // trailing: const Icon(Icons.delete),
        title: new Text(desc),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new GenericMap(
                      title: desc, latitude: loc.lat, longitude: loc.lon)));
        });
  }

  Widget _buildSavedLocations() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _saved.length,
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
          return _buildItem(_saved.elementAt(i));
        });
  }

  void handleUndo(BasicLocation item) {
    print('Undo $item');
    final int insertionIndex = lowerBound(_saved, item);
    setState(() {
      _saved.insert(insertionIndex, item);
    });
  }

  Widget _buildItem(BasicLocation item) {
    final ThemeData theme = Theme.of(context);
    return new Dismissible(
        key: new ObjectKey(item),
        direction: DismissDirection.horizontal,
        onDismissed: (DismissDirection direction) {
          setState(() {
            _saved.remove(item);
          });
          final String action = 'deleted';
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text('You $action item'), // ${item.index}'),
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

  Future<BasicLocation> getUserLocation() async {
    String error;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Location _location = new Location();
      Map<String, double> location = await _location.getLocation;
      error = null;
      print('location $location');

      // It seems that the lib fails with lat/lon values
      return new BasicLocation(
          lat: location['latitude'], lon: location['longitude']);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text('We don\'t have permission to get your location'),
        ));
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
            'I cannot get your current location. It\'s your ubication enabled?'),
      ));
      return BasicLocation.noLocation;
    }
  }

  @override
  void initState() {
    super.initState();
    length = _saved.length;
  }

  @override
  Widget build(BuildContext context) {
    print('Building Active Fires, saved $length');
    final title = 'Your locations';
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
        /* actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.location_searching), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              print('More button');
            },
          ),
        ], */
      ),
      body: length > 0
          ? _buildSavedLocations()
          : new Center(
              child: new CenteredColumn(children: <Widget>[
              new RoundedBtn(
                  icon: Icons.location_searching,
                  text: 'Add your position',
                  onPressed: onAddYourLocation,
                  backColor: fires600),
              const SizedBox(height: 26.0),
              new RoundedBtn(
                  icon: Icons.edit_location,
                  text: 'Add some other place',
                  onPressed: () {
                    onAddOtherLocation(context);
                  },
                  backColor: fires600),
            ])),
      floatingActionButton: length > 0
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              FloatingActionButton.extended(
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
              )
            ])
          : null,
    );
  }

  void onAddYourLocation() {
    Future<BasicLocation> location = getUserLocation();
    _saveLocation(location);
  }

  void onAddOtherLocation(BuildContext context) {
    Future<BasicLocation> location = openPlacesDialog(context);
    _saveLocation(location);
  }

  void _saveLocation(Future<BasicLocation> location) {
    location.then((newLocation) {
      if (newLocation != BasicLocation.noLocation)
        this.setState(() {
          _saved.add(newLocation);
          length = _saved.length;
        });
    });
  }
}

class ActiveFiresPage extends StatefulWidget {
  static const String routeName = '/fires';

  ActiveFiresPage();

  @override
  _ActiveFiresPageState createState() => _ActiveFiresPageState();
}
