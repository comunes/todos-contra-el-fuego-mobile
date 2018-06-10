import 'package:flutter/material.dart';
import 'basicLocation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'colors.dart';
import 'mainDrawer.dart';
import 'customBottomAppBar.dart';
import 'dart:core';

class LeafletMap extends StatefulWidget {
  final BasicLocation location;
  final String title;
  final int numFires;
  final String kmAround;

  LeafletMap({@required this.title, @required this.location,
  @required this.numFires, @required this.kmAround
  });

  @override
  _LeafletMapState createState() => _LeafletMapState(title: title, location: location,
    numFires: numFires, kmAround: kmAround
  );
}

class _LeafletMapState extends State<LeafletMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BasicLocation location;
  final String title;
  final int numFires;
  final String kmAround;

  _LeafletMapState({@required this.title, @required this.location,
    @required this.numFires, @required this.kmAround
  });
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        // drawer: new MainDrawer(context),
        appBar: new AppBar(
          title: new Text(title),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {

          },
          icon: const Icon(Icons.notifications_none, color: fires600),
          label: new Text('Subscribe', style: const TextStyle(color: fires600),),
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: new CustomBottomAppBar(
            fabLocation: FloatingActionButtonLocation.centerFloat,
            showNotch: false,
            color: fires100,
            mainAxisAlignment: MainAxisAlignment.center,
            actions: listWithoutNulls(<Widget>[
              numFires > 0 ?
              new Text('${numFires.toString()} fires at $kmAround км around this area'):
              new Text('There is no fires at $kmAround км around this area'),
              SizedBox(width: 10.0)
            ])),
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
