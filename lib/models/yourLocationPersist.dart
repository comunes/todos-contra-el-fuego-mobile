import 'dart:async';
import 'dart:convert';

import 'package:fires_flutter/models/yourLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart' as globals;

final String locationKey = 'yourlocations';

Future<List<YourLocation>> loadYourLocations() async {
  return await globals.prefs.then((prefs) {
    return loadYourLocationsWithPrefs(prefs);
  });
}

persistYourLocations(List<YourLocation> yl) {
  globals.prefs.then((prefs) {
    List<String> yourLocationsAsString = [];
    yl.forEach((location) {
      yourLocationsAsString.add(json.encode(location.toJson()));
    });
    prefs.setStringList(locationKey, yourLocationsAsString);
  });
}

Future<List<YourLocation>> loadYourLocationsWithPrefs(
    SharedPreferences prefs) async {
  return await globals.prefs.then((prefs) {
    List<String> yourLocations = prefs.getStringList(locationKey);
    if (yourLocations == null) {
      yourLocations = [];
      persistYourLocations(<YourLocation>[]);
    }
    List<YourLocation> persistedList = List<YourLocation>();
    yourLocations.forEach((locationString) {
      Map locationMap = json.decode(locationString);
      persistedList.add(YourLocation.fromJson(locationMap));
    });
    return persistedList;
  });
}
