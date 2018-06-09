import 'package:flutter/material.dart';
import 'firesApp.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'basicLocationPersist.dart';

Future<String> getGMapKey() async {
  Secret secret = await SecretLoader(secretPath: 'assets/private-settings.json')
      .load('gmap_key');
  return secret.apiKey;
}

void main() {
  getGMapKey().then((String gmapKey) {
    globals.gmapKey = gmapKey;
    globals.prefs.then((prefs) {
      loadYourLocations(prefs);

      // Run baby run!
      runApp(new FiresApp());
    });
  });
}
