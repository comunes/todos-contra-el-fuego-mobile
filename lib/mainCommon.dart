import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'firebaseMessagingConf.dart';
import 'firesApp.dart';
import 'globals.dart' as globals;
import 'models/appState.dart';
import 'models/firesApi.dart';
import 'redux/fetchDataMiddleware.dart';
import 'redux/reducers.dart';
import 'package:fires_flutter/models/yourLocationPersist.dart';
import 'package:fires_flutter/models/yourLocation.dart';

Future<Map<String, dynamic>> loadSecrets() async {
  return await SecretLoader(secretPath: 'assets/private-settings.json').load();
}

void mainCommon(List<Middleware<AppState>> otherMiddleware) {
  globals.getIt.registerSingleton<FiresApi>(new FiresApi());
  loadSecrets().then((secrets) {

    final store = new Store<AppState>(appStateReducer,
        initialState: new AppState(
            gmapKey: secrets['gmapKey'],
            firesApiKey: secrets['firesApiKey'],
            firesApiUrl: secrets['firesApiUrl'] + "api/v1/"),
        middleware: List.from(otherMiddleware)..add(fetchYourLocationsMiddleware));

    // FIXME remove this later
    globals.firesApiKey = store.state.firesApiKey;
    globals.firesApiUrl = store.state.firesApiUrl;
    globals.gmapKey = store.state.gmapKey;

    globals.prefs.then((prefs) {
      loadYourLocationsWithPrefs(prefs);
      firebaseConfig(store);

      // Run baby run!
      runApp(new FiresApp(store));
    });

    // Listen to store changes, and re-render when the state is updated
    // store.onChange.listen((state) {
    // });

  });

}
