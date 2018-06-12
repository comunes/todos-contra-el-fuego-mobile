import 'dart:convert';
import 'basicLocation.dart';
import 'globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';
final String locationKey = 'yourlocations';

void loadYourLocations() {
  globals.prefs.then((prefs) {
    loadYourLocationsWithPrefs(prefs);
  });
}

persistYourLocations() {
  globals.prefs.then((prefs) {
    List<String> yourLocationsAsString = [];
    globals.yourLocations.forEach((location) {
      yourLocationsAsString.add(json.encode(location.toJson()));
    });
    prefs.setStringList(locationKey, yourLocationsAsString);
  });
}

void loadYourLocationsWithPrefs(SharedPreferences prefs) {
  globals.prefs.then((prefs) {
    List<String> yourLocations = prefs.getStringList(locationKey);
    if (yourLocations == null) {
      yourLocations = [];
      persistYourLocations();
    }
    yourLocations.forEach((locationString) {
      Map locationMap = json.decode(locationString);
      globals.yourLocations.add(BasicLocation.fromJson(locationMap));
    });
  });
}
