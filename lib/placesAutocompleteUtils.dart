import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';

import 'package:fires_flutter/models/yourLocation.dart';
import 'generated/i18n.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

Future<YourLocation> openPlacesDialog(GlobalKey<ScaffoldState> sc) async {
  Mode _mode = Mode.overlay;
  String gmapKey = Injector.getInjector().get<String>(key: "gmapKey");
  GoogleMapsPlaces _places = new GoogleMapsPlaces(gmapKey);
  Prediction p = await showGooglePlacesAutocomplete(
      context: sc.currentContext,
      hint: S.of(sc.currentContext).typeTheNameOfAPlace,
      apiKey: gmapKey,
      onError: (res) {
        sc.currentState
            .showSnackBar(new SnackBar(content: new Text(res.errorMessage)));
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
    return new YourLocation(lat: lat, lon: lng, description: p.description);
  }
  return YourLocation.noLocation;
}
