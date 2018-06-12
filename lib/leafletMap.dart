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
import 'slider.dart';
import 'customMapPlugin.dart';
import 'package:just_debounce_it/just_debounce_it.dart';

enum MarkType { position, fire, industry, falsePos }

class LeafletMap extends StatefulWidget {
  final BasicLocation location;
  final String title;

  LeafletMap({@required this.title, @required this.location});

  @override
  _LeafletMapState createState() =>
      _LeafletMapState(title: title, location: location);
}

class _LeafletMapState extends State<LeafletMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BasicLocation location;
  final String title;
  int numFires;
  int kmAround = 100;
  List<dynamic> fires = [];
  List<dynamic> falsePos = [];
  List<dynamic> industries = [];

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
        print(resultDecoded);
        numFires = resultDecoded['real'];
        fires = resultDecoded['fires'];
        falsePos = resultDecoded['falsePos'];
        industries = resultDecoded['industries'];

        var firesCount = fires.length;
        var industriesCount = industries.length;
        var falsePosCount = falsePos.length;

        print(
            'fire: $firesCount falsePos: $falsePosCount industries: $industriesCount');
      });
    });
  }

  _LeafletMapState({@required this.title, @required this.location});

  @override
  Widget build(BuildContext context) {
    MapOptions mapOptions = new MapOptions(
        center: new LatLng(this.location.lat, this.location.lon),
        plugins: [new ZoomMapPlugin()],
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
    var fmap = new FlutterMap(
      options: mapOptions,
      mapController: mapController,
      layers: [
        new TileLayerOptions(
          maxZoom: 6.0,
          subdomains: ['a', 'b', 'c'],
          urlTemplate: 'https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
          additionalOptions: {
            // 'opacity': '0.1',
            'attribution':
                '&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors'
          },
        ),
        new ZoomMapPluginOptions(),
        new MarkerLayerOptions(
          markers: buildMarkers(
              this.location, this.fires, this.industries, this.falsePos),
        ),
      ],
    );

    return new Scaffold(
        key: _scaffoldKey,
        // drawer: new MainDrawer(context),
        appBar: new AppBar(
          title: new Text(title),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: fires600),
          label: new Text(
            'Subscribe',
            style: const TextStyle(color: fires600),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: new CustomBottomAppBar(
            fabLocation: FloatingActionButtonLocation.centerFloat,
            showNotch: false,
            color: fires100,
            // height: 170.0,
            mainAxisAlignment: MainAxisAlignment.center,
            actions: listWithoutNulls(<Widget>[
              numFires == null
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
                  top: constraints.maxHeight - 160,
                  right: 10.0,
                  left: 10.0,
                  child: new CenteredRow(
                    // Fit sample:
                    // https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/map_controller.dart
                    children: <Widget>[
                      new FireDistanceSlider(
                          initialValue: kmAround,
                          onSlide: (distance) {
                            setState(() {
                              kmAround = distance;
                              Debounce.seconds(1, updateFireStats);
                            });
                          })
                    ],
                  ),
                )
              ]),
        ));
  }

  List<Marker> buildMarkers(BasicLocation yourLocation, List<dynamic> fires,
      List<dynamic> falsePos, List<dynamic> industries) {
    List<Marker> markers = [];
    markers.add(buildMarker(yourLocation, MarkType.position));
    falsePos.forEach((fire) {
      var coords = fire['geo']['coordinates'];
      var loc = BasicLocation(lon: coords[0], lat: coords[1]);
      markers.add(buildMarker(loc, MarkType.falsePos));
    });
    industries.forEach((fire) {
      // print(fire['geo']['coordinates']);
      var coords = fire['geo']['coordinates'];
      var loc = BasicLocation(lon: coords[0], lat: coords[1]);
      markers.add(buildMarker(loc, MarkType.industry));
    });
    fires.forEach((fire) {
      var loc = new BasicLocation(lat: fire['lat'], lon: fire['lon']);
      markers.add(buildMarker(loc, MarkType.fire));
    });
    return markers;
  }

  Marker buildMarker(location, MarkType type) {
    return new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(location.lat, location.lon),
      builder: (ctx) => new Container(
            child: buildImageMark(type),
          ),
    );
  }

  Widget buildImageMark(MarkType type) {
    switch (type) {
      case MarkType.position:
        return new Icon(Icons.location_on, color: fires600, size: 50.0);
      case MarkType.fire:
        return new Image.asset('images/fire-marker-l.png');
      case MarkType.industry:
        return new Image.asset('images/industry-marker-reg.png');
      case MarkType.falsePos:
      default:
        return new Image.asset('images/industry-marker.png');
    }
  }
}
