import 'package:flutter/material.dart';
import 'basicLocation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'colors.dart';
import 'mainDrawer.dart'
  '';
class LeafletMap extends StatefulWidget {
  final BasicLocation location;
  final String title;

  LeafletMap({@required this.title, @required this.location});

  @override
  _LeafletMapState createState() => _LeafletMapState(title: title, location: location);
}

class _LeafletMapState extends State<LeafletMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BasicLocation location;
  final String title;
  _LeafletMapState({@required this.title, @required this.location});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        // drawer: new MainDrawer(context),
        appBar: new AppBar(
          title: new Text(title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: const Icon(Icons.notifications_none),
          backgroundColor: Colors.orange,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: new MapBottomAppBar(
            menuCallback: () {
              // _scaffoldKey.currentState.openDrawer();
            },
            fabLocation: FloatingActionButtonLocation.centerDocked,
            showNotch: true,
            bottomActions: <Widget>[
              new Text('10 fires near you'),
              SizedBox(width: 10.0)
            ]),
        body:  new FlutterMap(
      options: new MapOptions(
        center: new LatLng(this.location.lat, this.location.lon),
        zoom: 13.0,
        // THIS does not works as expected
        // maxZoom: 6.0,
        onPositionChanged: (positionCallback) {
          print('$positionCallback');
        }
      ),
      layers: [
        new TileLayerOptions(
          maxZoom: 6.0,
          urlTemplate: 'https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
          additionalOptions: {
            // 'opacity': '0.1',
            'attribution': '&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors'
          },
        ), /*
         new TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          additionalOptions: {
            // 'opacity': '0.1',
            'attribution': '&amp;copy <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors'
          },

        ), */
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(this.location.lat, this.location.lon),
              builder: (ctx) =>
              new Container(
                child: new Image.asset('images/fire-marker-l.png'),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

class MapBottomAppBar extends StatelessWidget {
  const MapBottomAppBar(
      {this.menuCallback,
      this.fabLocation,
      this.showNotch,
      this.bottomActions});

  final Color color = fires600;
  final FloatingActionButtonLocation fabLocation;
  final bool showNotch;
  final VoidCallback menuCallback;
  final List<Widget> bottomActions;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      /*  new IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          menuCallback();
          /* showModalBottomSheet<Null>(
            context: context,
            builder: (BuildContext context) => const _DemoDrawer(),
          ); */
        },
      ), */
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: const SizedBox()),
      );
    }

    rowContents.addAll(this.bottomActions);

    return new BottomAppBar(
      color: color,
      hasNotch: showNotch,
      child: new Row(children: rowContents),
    );
  }
}
