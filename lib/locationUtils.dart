import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'globals.dart' as globals;
import 'generated/i18n.dart';

Future<YourLocation> getUserLocation(
    GlobalKey<ScaffoldState> scaffoldKey) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    Location _location = new Location();
    Map<String, double> location = await _location.getLocation;

    // It seems that the lib fails with lat/lon values
    var yourLocation = new YourLocation(
        lat: location['latitude'], lon: location['longitude']);
    var address;
    try {
      address = await getReverseLocation(yourLocation);
      yourLocation.description = address;
    } catch (e) {
      try {
        address = await getReverseLocation(yourLocation, true);
        yourLocation.description = address;
      } catch (e) {
        print('We cannot reverse geolocate');
      }
    }
    return yourLocation;
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
    return YourLocation.noLocation;
  }
}

Future<String> getReverseLocation(YourLocation loc,
    [bool external = false]) async {
  final coordinates = new Coordinates(loc.lat, loc.lon);
  var geoCoder = external ? Geocoder.google(globals.gmapKey) : Geocoder.local;
  var addresses = await geoCoder.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");
  return first.addressLine;
}
