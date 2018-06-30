import 'dart:async';
import 'dart:convert';

import 'package:fires_flutter/models/yourLocation.dart';

import '../globals.dart' as globals;

final String locationKey = 'yourlocations';

Future<List<YourLocation>> loadYourLocations() async {
  return await globals.prefs.then((prefs) {
    List<String> yourLocations = prefs.getStringList(locationKey);
    List<YourLocation> persistedList = List<YourLocation>();
    if (yourLocations == null) {
      yourLocations = [];
      // first run, init with empty list
      persistYourLocations(persistedList);
    }
    yourLocations.forEach((locationString) {
      Map locationMap = json.decode(locationString);
      persistedList.add(YourLocation.fromJson(locationMap));
    });
    return persistedList;
  });
}

persistYourLocations(List<YourLocation> yl) {
  globals.prefs.then((prefs) {
    List<String> ylAsString = [];
    yl.forEach((location) {
      ylAsString.add(json.encode(location.toJson()));
    });
    prefs.setStringList(locationKey, ylAsString);
  });
}
