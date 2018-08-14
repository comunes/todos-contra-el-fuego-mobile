import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
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
import 'package:package_info/package_info.dart';

Future<PackageInfo> loadPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo;
}

Future<Map<String, dynamic>> loadSecrets() async {
  return await SecretLoader(secretPath: 'assets/private-settings.json').load();
}

void mainCommon(List<Middleware<AppState>> otherMiddleware) {
  final injector = Injector.getInjector();
  injector.map<FiresApi>((i) => new FiresApi(), isSingleton: true);
  loadPackageInfo().then((packageInfo) {
    globals.appVersion = packageInfo.version;
    print('Running version ${packageInfo.version}');
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

      var useSentry = !globals.isDevelopment;

      SentryClient _sentry;
      if (useSentry) _sentry = SentryClient(dsn: secrets['sentryDSN']);

      // https://flutter.io/cookbook/maintenance/error-reporting/
      runZoned<Future<Null>>(() async {
        runApp(new FiresApp(store));
      }, onError: (error, stackTrace) {
        // Whenever an error occurs, call the `_reportError` function. This will send
        // Dart errors to our dev console or Sentry depending on the environment.
        _reportError(useSentry, _sentry, error, stackTrace);
      });

      // Listen to store changes, and re-render when the state is updated
      store.onChange.listen((state) {
        // print('Store onChange');
      });
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!useSentry) {
          // In development mode simply print to console.
          FlutterError.dumpErrorToConsole(details);
        } else {
          // In production mode report to the application zone to report to
          // Sentry.
          Zone.current.handleUncaughtError(details.exception, details.stack);
        }
      };
    });
  });
}

Future<Null> _reportError(bool useSentry, SentryClient sentry, dynamic error,
    dynamic stackTrace) async {
  // Print the exception to the console
  print('Caught error: $error');
  if (!useSentry) {
    // Print the full stacktrace in debug mode
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode
    sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
