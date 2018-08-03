import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/yourLocationPersist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:redux/redux.dart';
import 'package:sentry/sentry.dart';

import 'firesApp.dart';
import 'globals.dart' as globals;
import 'models/appState.dart';
import 'models/firesApi.dart';
import 'redux/fetchDataMiddleware.dart';
import 'redux/reducers.dart';

Future<Map<String, dynamic>> loadSecrets() async {
  return await SecretLoader(secretPath: 'assets/private-settings.json').load();
}

void mainCommon(List<Middleware<AppState>> otherMiddleware) {
  final injector = Injector.getInjector();
  injector.map<FiresApi>((i) => new FiresApi(), isSingleton: true);
  loadSecrets().then((secrets) {
    final store = new Store<AppState>(appStateReducer,
        initialState: new AppState(
            gmapKey: secrets['gmapKey'],
            firesApiKey: secrets['firesApiKey'],
          serverUrl: secrets['firesApiUrl'],
            firesApiUrl: secrets['firesApiUrl'] + "api/v1/"),
        middleware: List.from(otherMiddleware)
          ..add(fetchDataMiddleware));

    injector.map<Store<AppState>>((i) => store);
    injector.map<String>((i) => store.state.firesApiUrl, key: "firesApiUrl");
    injector.map<String>((i) => store.state.firesApiKey, key: "firesApiKey");
    injector.map<String>((i) => store.state.serverUrl, key: "serverUrl");
    injector.map<String>((i) => store.state.gmapKey, key: "gmapKey");

    VoidCallback mainFn = () {
      loadYourLocations().then((yl) {
        // Run baby run!
        runApp(new FiresApp(store));
      });
    };

    if (!globals.isDevelopment)
      // Run in production with sentry catch
      main(mainFn, secrets['sentryDSN']);
    else
      mainFn();

    // Listen to store changes, and re-render when the state is updated
    store.onChange.listen((state) {
      // print('Store onChange');
    });
  });
}

main(mainFn, key) async {
  SentryClient sentry = new SentryClient(dsn: key);
  mainFn();
  try {} catch (error, stackTrace) {
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
