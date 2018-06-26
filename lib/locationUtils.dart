import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'basicLocation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'globals.dart' as globals;
import 'generated/i18n.dart';

Future<BasicLocation> getUserLocation(
    GlobalKey<ScaffoldState> scaffoldKey) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    Location _location = new Location();
    Map<String, double> location = await _location.getLocation;

    // It seems that the lib fails with lat/lon values
    var basicLocation = new BasicLocation(
        lat: location['latitude'], lon: location['longitude']);
    var address;
    try {
      address = await getReverseLocation(basicLocation);
      basicLocation.description = address;
    } catch (e) {
      try {
        address = await getReverseLocation(basicLocation, true);
        basicLocation.description = address;
      } catch (e) {
        print('We cannot reverse geolocate');
      }
    }
    return basicLocation;
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(S.of(scaffoldKey.currentContext).notPermsUbication),
      ));
    } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {}
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(S.of(scaffoldKey.currentContext).isYourUbicationEnabled
          ),
    ));
    return BasicLocation.noLocation;
  }
}

Future<String> getReverseLocation(BasicLocation loc,
    [bool external = false]) async {
  final coordinates = new Coordinates(loc.lat, loc.lon);
  var geoCoder = external ? Geocoder.google(globals.gmapKey) : Geocoder.local;
  var addresses = await geoCoder.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");
  return first.addressLine;
}
