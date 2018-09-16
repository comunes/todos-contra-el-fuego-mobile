import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'generated/i18n.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

Future<YourLocation> getUserLocation(
    GlobalKey<ScaffoldState> scaffoldKey) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    Location _location = new Location();
    Map<String, double> location = await _location.getLocation;

    // It seems that the lib fails with lat/lon values
    var yl = new YourLocation(
        lat: location['latitude'], lon: location['longitude']);
    var address;
    try {
      address = await getReverseLocation(lat: yl.lat, lon: yl.lon);
      yl.description = address;
    } catch (e) {
      try {
        address = await getReverseLocation(lat: yl.lat, lon: yl.lon, external: true);
        yl.description = address;
      } catch (e) {
        print('We cannot reverse geolocate');
      }
    }
    return yl;
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

Future<String> getReverseLocation({@required lat, @required lon,
    bool external = false}) async {
  final coordinates = new Coordinates(lat, lon);
  var geoCoder = external ? Geocoder.google(Injector.getInjector().get<String>(key: "gmapKey")) : Geocoder.local;
  var addresses = await geoCoder.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");
  return first.addressLine;
}
