import 'dart:convert';
import 'basicLocation.dart';
import 'globals.dart' as globals;
final String locationKey = 'yourlocations';

void loadYourLocations(prefs) {
  List<String> yourLocations = prefs.getStringList(locationKey);
  if (yourLocations == null) {
    yourLocations = [];
    persistYourLocations(prefs);
  }
  yourLocations.forEach((locationString) {
    Map locationMap = json.decode(locationString);
    globals.yourLocations.add(BasicLocation.fromJson(locationMap));
  });
}

persistYourLocations(prefs) {
  List<String> yourLocationsAsString = [];
  globals.yourLocations.forEach((location) {
    yourLocationsAsString.add(json.encode(location.toJson()));
  });
  prefs.setStringList(locationKey, yourLocationsAsString);
}