import 'dart:async';

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:sentry/sentry.dart';

import 'globals.dart' as globals;

var useSentry = !globals.isDevelopment;

Future<Null> reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console

  print('Caught error: $error');
  if (!useSentry) {
    // Print the full stacktrace in debug mode
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode
    Injector.getInjector().get<SentryClient>().captureException(
          exception: error,
          stackTrace: stackTrace,
        );
  }
}
