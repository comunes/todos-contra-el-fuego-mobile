import 'package:flutter/material.dart';
import 'basicLocation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'colors.dart';
import 'customBottomAppBar.dart';
import 'dart:core';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'fireMarker.dart';
import 'zoomMapPlugin.dart';
import 'dummyMapPlugin.dart';
import 'fireMarkType.dart';
import 'slider.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


enum MapOperation { view, subscriptionConfirm, unsubscribe }

class GenericMap extends StatefulWidget {
  final BasicLocation location;
  final String title;
  final MapOperation operation;

  GenericMap(
      {@required this.title,
      @required this.location,
      @required this.operation});

  @override
  _GenericMapState createState() =>
      _GenericMapState(title: title, location: location, operation: operation);
}

class _GenericMapState extends State<GenericMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();


  final BasicLocation location;
  final String title;
  int numFires;
  int kmAround = 100;
  List<dynamic> fires = [];
  List<dynamic> falsePos = [];
  List<dynamic> industries = [];
  MapOperation operation;

  @override
  void initState() {
    super.initState();
    updateFireStats();
  }

  void updateFireStats() {
    var url = '${globals.firesApiUrl}fires-in-full/${globals
      .firesApiKey}/${location.lat}/${location.lon}/$kmAround';
    http.read(url).then((result) {
      setState(() {
        var resultDecoded = json.decode(result);
        // print(resultDecoded);
        numFires = resultDecoded['real'];
        fires = resultDecoded['fires'];
        falsePos = resultDecoded['falsePos'];
        industries = resultDecoded['industries'];

        if (globals.isDevelopment) {
          var firesCount = fires.length;
          var industriesCount = industries.length;
          var falsePosCount = falsePos.length;
          print(
              'real: $numFires, fire: $firesCount falsePos: $falsePosCount industries: $industriesCount');
        }
      });
    });
  }

  _GenericMapState(
      {@required this.title,
      @required this.location,
      @required this.operation});

  @override
  Widget build(BuildContext context) {
    print('Build map with operation: $operation');
    MapOptions mapOptions = new MapOptions(
        center: new LatLng(this.location.lat, this.location.lon),
        plugins: globals.isDevelopment
            ? [new ZoomMapPlugin()]
            : [new DummyMapPlugin()],
        // this works ?
        // interactive: false,
        zoom: 13.0,
        // THIS does not works as expected
        // maxZoom: 6.0,
        onPositionChanged: (positionCallback) {
          // decouple
          // print('${positionCallback.center}, ${positionCallback.zoom}');
        });
    var mapController = new MapController();
    // mapController.fitBounds(bounds);
    // mapController.center
    var fmap = new Opacity(
        opacity: operation == MapOperation.subscriptionConfirm ? 0.5 : 1.0,
        child: new FlutterMap(
          options: mapOptions,
          mapController: mapController,
          layers: [
            new TileLayerOptions(
              maxZoom: 6.0,
              subdomains: ['a', 'b', 'c'],
              urlTemplate:
                  'https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
              additionalOptions: {
                // 'opacity': '0.1',
                'attribution':
                    '&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors'
              },
            ),
            globals.isDevelopment
                ? new ZoomMapPluginOptions()
                : new DummyMapPluginOptions(),
            new MarkerLayerOptions(
              markers: buildMarkers(
                  this.location, this.fires, this.industries, this.falsePos),
            ),
          ],
        ));

    return new Scaffold(
        key: _scaffoldKey,
        // drawer: new MainDrawer(context),
        appBar: new AppBar(
          title: new Text(title),
        ),
        floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    switch (operation) {
                      case MapOperation.view:
                        operation = MapOperation.subscriptionConfirm;
                        break;
                      case MapOperation.subscriptionConfirm:
                        // IOS specific
                        _firebaseMessaging.requestNotificationPermissions();
                        operation = MapOperation.unsubscribe;
                        break;
                      case MapOperation.unsubscribe:
                        operation = MapOperation.view;
                        break;
                    }
                  });
                },
                icon: new Icon(
                    operation == MapOperation.view
                        ? Icons.notifications_active
                        : operation == MapOperation.subscriptionConfirm
                            ? Icons.check
                            : Icons.notifications_off,
                    color: fires600),
                label: new Text(
                  operation == MapOperation.view
                      ? 'Subscribe to fires notifications'
                      : operation == MapOperation.subscriptionConfirm
                          ? 'Confirm'
                          : 'Unsubscribe',
                  style: const TextStyle(color: fires600),
                ),
                backgroundColor: Colors.white,
              )
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: new CustomBottomAppBar(
            fabLocation: FloatingActionButtonLocation.centerFloat,
            showNotch: false,
            color: fires100,
            // height: 170.0,
            mainAxisAlignment: MainAxisAlignment.center,
            actions: listWithoutNulls(<Widget>[
              operation == MapOperation.subscriptionConfirm|| numFires == null
                  ? null
                  : numFires > 0
                      ? new Text('${numFires.toString()} fires at ${kmAround
            .toString()} км around this area')
                      : new Text(
                          'There is no fires at ${kmAround.toString()} км around this area'),
              SizedBox(width: 10.0)
            ])),
        body: LayoutBuilder(
          builder: (context, constraints) =>
              Stack(fit: StackFit.expand, children: <Widget>[
                // Material(color: Colors.yellowAccent),
                fmap,
                Positioned(
                  top: constraints.maxHeight - 200,
                  right: 10.0,
                  left: 10.0,
                  child: new CenteredRow(
                    // Fit sample:
                    // https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/map_controller.dart
                    children: operation == MapOperation.subscriptionConfirm
                        ? <Widget>[
                            new FireDistanceSlider(
                                initialValue: kmAround,
                                onSlide: (distance) {
                                  setState(() {
                                    kmAround = distance;
                                    Debounce.seconds(1, updateFireStats);
                                  });
                                })
                          ]
                        : [],
                  ),
                )
              ]),
        ));
  }

  List<Marker> buildMarkers(BasicLocation yourLocation, List<dynamic> fires,
      List<dynamic> falsePos, List<dynamic> industries) {
    List<Marker> markers = [];
    const calibrate = false; // useful when we change the fire icons size
    markers.add(FireMarker(yourLocation, FireMarkType.position));
    if (calibrate) markers.add(FireMarker(yourLocation, FireMarkType.pixel));
    falsePos.forEach((fire) {
      var coords = fire['geo']['coordinates'];
      var loc = BasicLocation(lon: coords[0], lat: coords[1]);
      markers.add(FireMarker(loc, FireMarkType.falsePos));
      if (calibrate) markers.add(FireMarker(loc, FireMarkType.pixel));
    });
    industries.forEach((fire) {
      // print(fire['geo']['coordinates']);
      var coords = fire['geo']['coordinates'];
      var loc = BasicLocation(lon: coords[0], lat: coords[1]);
      markers.add(FireMarker(loc, FireMarkType.industry));
      if (calibrate) markers.add(FireMarker(loc, FireMarkType.pixel));
    });
    fires.forEach((fire) {
      var loc = new BasicLocation(lat: fire['lat'], lon: fire['lon']);
      markers.add(FireMarker(loc, FireMarkType.fire));
      markers.add(FireMarker(loc, FireMarkType.pixel));
    });
    return markers;
  }
}
