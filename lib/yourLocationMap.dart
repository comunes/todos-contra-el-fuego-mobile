import 'dart:core';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fires_flutter/models/basicLocation.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';

import 'colors.dart';
import 'dummyMapPlugin.dart';
import 'fireMarkType.dart';
import 'fireMarker.dart';
import 'generated/i18n.dart';
import 'globals.dart' as globals;
import 'models/appState.dart';
import 'models/fireMapState.dart';
import 'redux/actions.dart';
import 'slider.dart';
import 'yourLocationMapBottom.dart';
import 'zoomMapPlugin.dart';

@immutable
class _ViewModel {
  final FireMapState mapState;
  final OnSubscribeFunction onSubs;
  final OnSubscribeConfirmedFunction onSubsConfirmed;
  final OnUnSubscribeFunction onUnSubs;
  final OnSubscribeDistanceChangeFunction onSlide;
  final OnLocationEdit onEdit;
  final OnLocationEditConfirm onEditConfirm;
  final OnLocationEditCancel onEditCancel;
  final OnLocationEditing onEditing;

  _ViewModel(
      {@required this.mapState,
      @required this.onSubs,
      @required this.onSubsConfirmed,
      @required this.onUnSubs,
      @required this.onSlide,
      @required this.onEdit,
      @required this.onEditing,
      @required this.onEditConfirm,
      @required this.onEditCancel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          mapState == other.mapState;

  @override
  int get hashCode => mapState.hashCode;
}

class YourLocationMap extends StatefulWidget {
  @override
  _YourLocationMapState createState() => _YourLocationMapState();
}

class _YourLocationMapState extends State<YourLocationMap> {
  // This needs to be stateful so when resizes don't get a new globalkey
  // https://github.com/flutter/flutter/issues/1632#issuecomment-180478202
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  YourLocation _location;
  YourLocation _initialLocation;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true,
        onInitialBuild: (store) {
          _initialLocation = _location.copyWith();
        },
        converter: (store) {
          print('New map viewer');
          return new _ViewModel(
              onSubs: (loc) {
                store.dispatch(new SubscribeAction());
              },
              onSubsConfirmed: (loc) {
                loc.subscribed = true;
                store.dispatch(new SubscribeConfirmAction(loc));
              },
              onUnSubs: (loc) {
                loc.subscribed = false;
                store.dispatch(new UnSubscribeAction(loc));
              },
              onSlide: (loc) {
                store.dispatch(new UpdateYourLocationMapAction(loc));
              },
              onEdit: (loc) => store.dispatch(new EditYourLocationAction(loc)),
              onEditing: (loc) {
                store.dispatch(new UpdateYourLocationMapAction(loc));
              },
              onEditCancel: (loc) =>
                  store.dispatch(new EditCancelYourLocationAction(loc)),
              onEditConfirm: (loc) {
                store.dispatch(new UpdateYourLocationAction(loc));
                store.dispatch(new UpdateYourLocationMapAction(loc));
                store.dispatch(new EditConfirmYourLocationAction(loc));
              },
              mapState: store.state.fireMapState);
        },
        builder: (context, view) {
          YourLocation location = view.mapState.yourLocation;
          _location = location.copyWith();
          print('New map builder with ${_location.description}');

          assert(_location != null);
          FireMapState mapState = view.mapState;
          FireMapStatus status = mapState.status;
          print('Build map with status: $status');

          MapOptions mapOptions = new MapOptions(
              center: new LatLng(_location.lat, _location.lon),
              plugins: globals.isDevelopment
                  ? [new ZoomMapPlugin()]
                  : [new DummyMapPlugin()],
              // this works ?
              interactive: false,
              zoom: 13.0,
              // THIS does not works as expected
              // maxZoom: 6.0,
              onTap: (callback) {
                print('On tap ${callback}');
                if (status == FireMapStatus.edit) {
                  _location = _location.copyWith(
                      lat: callback.latitude, lon: callback.longitude);
                  view.onEditing(_location);
                }
              },
              onPositionChanged: (positionCallback) {
                // print('${positionCallback.center}, ${positionCallback.zoom}');
              });
          var mapController = new MapController();

          // mapController.fitBounds(bounds);
          // mapController.center

          final btnText = status == FireMapStatus.view
              ? S.of(context).toFiresNotifications
              : status == FireMapStatus.subscriptionConfirm
                  ? S.of(context).confirm
                  : S.of(context).unsubscribe;
          final btnIcon = status == FireMapStatus.view
              ? Icons.notifications_active
              : status == FireMapStatus.subscriptionConfirm
                  ? Icons.check
                  : Icons.notifications_off;
          FlutterMap map = new FlutterMap(
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
                markers: buildMarkers(_location, mapState.fires,
                    mapState.industries, mapState.falsePos),
              ),
            ],
          );
          // mapController.
          /* FlutterMapState leafletState = map.createState();
          leafletState.mapState.onMoved.listen((Null) {

            ;
          }); */
          // Do something with it
          return new Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomPadding: true,
              appBar: new AppBar(
                title: status == FireMapStatus.edit
                    ? new TextField(
                        // autofocus: true,
                        key: new Key('LocationDescField'),
                        keyboardType: TextInputType.text,

                        decoration: new InputDecoration(),
                        controller: new TextEditingController.fromValue(
                            new TextEditingValue(
                                text: _location.description,
                                selection: new TextSelection.collapsed(
                                    offset: _location.description.length - 1))),
                        onChanged: (newDesc) {
                          _location = _location.copyWith(description: newDesc);
                        },
                      )
                    : new Text(_location.description),
                actions: buildAppBarActions(status, view, _location),
              ),
              floatingActionButton: status == FireMapStatus.edit
                  ? null
                  : FloatingActionButton.extended(
                      onPressed: () {
                        switch (status) {
                          case FireMapStatus.view:
                            view.onSubs(_location);
                            break;
                          case FireMapStatus.subscriptionConfirm:
                            view.onSubsConfirmed(_location);
                            // IOS specific
                            _firebaseMessaging.requestNotificationPermissions();
                            break;
                          case FireMapStatus.unsubscribe:
                            view.onUnSubs(_location);
                            break;
                          case FireMapStatus.edit:
                            break;
                        }
                      },
                      // https://github.com/flutter/flutter/issues/17583
                      heroTag: "firesmap" + _location.id.toHexString(),
                      icon: new Icon(btnIcon, color: fires600),
                      label: new Text(
                        btnText,
                        style: const TextStyle(color: fires600),
                      ),
                      backgroundColor: Colors.white,
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              bottomNavigationBar: new YourLocationMapBottom(
                  onSave: () => view.onEditConfirm(_location),
                  onCancel: () => view.onEditCancel(_initialLocation),
                  state: view.mapState),
              body: LayoutBuilder(
                  builder: (context, constraints) =>
                      Stack(fit: StackFit.expand, children: <Widget>[
                        // Material(color: Colors.yellowAccent),
                        new Opacity(
                            opacity: status == FireMapStatus.subscriptionConfirm
                                ? 0.5
                                : 1.0,
                            child: map),
                        Positioned(
                          top: constraints.maxHeight - 200,
                          right: 10.0,
                          left: 10.0,
                          child: new CenteredRow(
                              // Fit sample:
                              // https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/map_controller.dart
                              children:
                                  status == FireMapStatus.subscriptionConfirm ||
                                          (status == FireMapStatus.edit &&
                                              _location.subscribed)
                                      ? <Widget>[
                                          new FireDistanceSlider(
                                              initialValue: _location.distance,
                                              onSlide: (distance) {
                                                _location.distance = distance;
                                                view.onSlide(_location);
                                              })
                                        ]
                                      : []),
                        )
                      ])));
        });
  }

  List<Widget> buildAppBarActions(
      FireMapStatus status, _ViewModel view, YourLocation location) {
    switch (status) {
      case FireMapStatus.view:
      case FireMapStatus.unsubscribe:
        return <Widget>[
          new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () => view.onEdit(location))
        ];
      case FireMapStatus.edit:
        return <Widget>[
          new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () => view.onEditConfirm(_location))
        ];
      default:
        return <Widget>[];
    }
  }

  List<Marker> buildMarkers(YourLocation yourLocation, List<dynamic> fires,
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
