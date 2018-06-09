import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'globals.dart' as globals;

class PlacesAutocompleteWidget extends StatefulWidget {
  static const String routeName = '/place';

  PlacesAutocompleteWidget();

  @override
  _PlacesAutocompleteWidgetState createState() =>
      _PlacesAutocompleteWidgetState();
}

// to get places detail (lat/lng)

final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();

GoogleMapsPlaces _places;

class _PlacesAutocompleteWidgetState extends State<PlacesAutocompleteWidget> {
  Mode _mode = Mode.overlay;

  _PlacesAutocompleteWidgetState() {
    _places = new GoogleMapsPlaces(globals.gmapKey);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: homeScaffoldKey,
      appBar: new AppBar(
        title: new Text("My App"),
      ),
      body:

          new RaisedButton.icon(
            icon: const Icon(Icons.location_searching),
            label: new Text('Write a location'),
            onPressed: () async {
              // show input autocomplete with selected mode
              // then get the Prediction selected
              Prediction p = await showGooglePlacesAutocomplete(
                  context: context,
                  hint: 'Type the name of place, region, etc',
                  apiKey: globals.gmapKey,
                  onError: (res) {
                    homeScaffoldKey.currentState.showSnackBar(
                        new SnackBar(content: new Text(res.errorMessage)));
                  },
                  mode: _mode,
                  // FIXME
                  language: "es",
                  components: [new Component(Component.country, "es")]);
              displayPrediction(p, homeScaffoldKey.currentState);
            },
          )

    );
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
        new SnackBar(content: new Text("${p.description} - $lat/$lng")));
  }
}
