import 'package:flutter/material.dart';
import 'firesApp.dart';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'basicLocationPersist.dart';
import 'firebaseMessagingConf.dart';

Future<Map<String, dynamic>> loadSecrets() async {
  return await SecretLoader(secretPath: 'assets/private-settings.json').load();
}

void mainCommon() {
  loadSecrets().then((secrets) {
    globals.gmapKey = secrets['gmapKey'];
    globals.firesApiKey = secrets['firesApiKey'];
    globals.firesApiUrl = secrets['firesApiUrl'] + "api/v1/";
    globals.prefs.then((prefs) {
      loadYourLocationsWithPrefs(prefs);
      firebaseConfig();

      // Run baby run!
      runApp(new FiresApp());
    });
  });
}
