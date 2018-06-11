import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'basicLocation.dart';
import 'globals.dart' as globals;

Future<BasicLocation> openPlacesDialog(BuildContext context) async {
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = new GoogleMapsPlaces(globals.gmapKey);
  Prediction p = await showGooglePlacesAutocomplete(
      context: context,
      hint: 'Type the name of a place, region, etc',
      apiKey: globals.gmapKey,
      onError: (res) {
        /* homeScaffoldKey.currentState.showSnackBar(
                        new SnackBar(content: new Text(res.errorMessage))); */
        print('Error $res');
      },
      mode: _mode,
      // FIXME
      language: "es",
      components: [
        // This limit the search too much
        // new Component(Component.country, "es")
      ]);
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    return new BasicLocation(lat: lat, lon: lng, description: p.description);
  }
  return BasicLocation.noLocation;
}
