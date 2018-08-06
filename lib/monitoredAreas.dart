import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong/latlong.dart';

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'generated/i18n.dart';
import 'mainDrawer.dart';
import 'models/appState.dart';

class _ViewModel {
  List<Polyline> monitoredAreas;

  _ViewModel(this.monitoredAreas);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          monitoredAreas == other.monitoredAreas;

  @override
  int get hashCode => monitoredAreas.hashCode;
}

class MonitoredAreasPage extends StatelessWidget {
  static const String routeName = "monitoredAreasMap";

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) {
          return new _ViewModel(store.state.monitoredAreas);
        },
        builder: (context, view) {
          return new Scaffold(
            appBar:
                new AppBar(title: new Text(S.of(context).monitoredAreasTitle)),
            drawer: new MainDrawer(context, MonitoredAreasPage.routeName),
            bottomNavigationBar: new CustomBottomAppBar(
                fabLocation: FloatingActionButtonLocation.centerDocked,
                showNotch: true,
                color: fires100,
                mainAxisAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  new Flexible(
                      child: new Padding(
                          padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Text(S.of(context).mapPrivacy,
                                    style: new TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black38))
                              ])))
                ]),
            body: !(view.monitoredAreas is List)
                ? new SpinKitPulse(color: fires600)
                : new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: [
                        new Padding(
                          padding: new EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                          child: new Text(S.of(context).inGreenMonitoredAreas),
                        ),
                        new Flexible(
                          child: new FlutterMap(
                            options: new MapOptions(
                              center: new LatLng(53.5775, 3.106111),
                              zoom: 1.0,
                            ),
                            layers: [
                              new TileLayerOptions(
                                  urlTemplate:
                                      "https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              new PolylineLayerOptions(
                                polylines: view.monitoredAreas,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
