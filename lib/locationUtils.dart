import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'basicLocation.dart';
import 'package:flutter/material.dart';

Future<BasicLocation> getUserLocation(GlobalKey<ScaffoldState> scaffoldKey) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Location _location = new Location();
      Map<String, double> location = await _location.getLocation;
      print('location $location');

      // It seems that the lib fails with lat/lon values
      return new BasicLocation(
          lat: location['latitude'], lon: location['longitude']);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text('We don\'t have permission to get your location'),
        ));
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      }
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
            'I cannot get your current location. It\'s your ubication enabled?'),
      ));
      return BasicLocation.noLocation;
    }
  }
