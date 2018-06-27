import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'firebaseMessagingConf.dart';
import 'firesApp.dart';
import 'globals.dart' as globals;
import 'models/appState.dart';
import 'redux/reducers.dart';
import 'yourLocationPersist.dart';
import 'models/firesApi.dart';

import 'package:get_it/get_it.dart';

Future<Map<String, dynamic>> loadSecrets() async {
  return await SecretLoader(secretPath: 'assets/private-settings.json').load();
}

void mainCommon(List<Middleware<AppState>> otherMiddleware) {
  final store = new Store<AppState>(
    appStateReducer,
    initialState: new AppState(),
    middleware: otherMiddleware,
  );

  globals.getIt.registerSingleton<FiresApi>(new FiresApi());

  loadSecrets().then((secrets) {
    globals.gmapKey = secrets['gmapKey'];
    globals.firesApiKey = secrets['firesApiKey'];
    globals.firesApiUrl = secrets['firesApiUrl'] + "api/v1/";
    globals.prefs.then((prefs) {
      loadYourLocationsWithPrefs(prefs);
      firebaseConfig();

      // Run baby run!
      runApp(new FiresApp(store));
    });
  });

  // Listen to store changes, and re-render when the state is updated
  // store.onChange.listen(render);
}
