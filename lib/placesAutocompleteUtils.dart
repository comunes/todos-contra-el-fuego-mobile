import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'basicLocation.dart';
import 'globals.dart' as globals;
import 'generated/i18n.dart';

Future<BasicLocation> openPlacesDialog(GlobalKey<ScaffoldState> sc) async {
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = new GoogleMapsPlaces(globals.gmapKey);
  Prediction p = await showGooglePlacesAutocomplete(
      context: sc.currentContext,
      hint: S.of(sc.currentContext).typeTheNameOfAPlace,
      apiKey: globals.gmapKey,
      onError: (res) {
       /* sc.currentState.showSnackBar(
                        new SnackBar(content: new Text(res.errorMessage))); */
        print('Error $res');
      },
      mode: _mode,
      language: Localizations.localeOf(sc.currentContext).languageCode,
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
