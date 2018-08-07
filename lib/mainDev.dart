import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'globals.dart' as globals;
import 'mainCommon.dart';

enum LogLevel { none, actions, all }

LoggingMiddleware customLogPrinter<State>({
  Logger logger,
  Level level = Level.INFO,
  MessageFormatter<State> formatter = LoggingMiddleware.singleLineFormatter,
}) {
  final middleware = new LoggingMiddleware<State>(
    logger: logger,
    level: level,
    formatter: formatter,
  );

  middleware.logger.onRecord
      .where((record) => record.loggerName == middleware.logger.name)
      .listen((Object object) {
    debugPrint("$object");
  });

  return middleware;
}

void main() {
  globals.isDevelopment = true;

  String onlyLogActionFormatter<State>(
    State state,
    dynamic action,
    DateTime timestamp,
  ) {
    return ">>>>> ${action.toString().replaceAll('Instance of ', '')}";
  }

  LogLevel logRedux = LogLevel.none;

  List<Middleware> devMiddlewares = logRedux == LogLevel.none
      ? []
      : [
          customLogPrinter(
              formatter: logRedux == LogLevel.all
                  ? LoggingMiddleware.multiLineFormatter
                  : onlyLogActionFormatter)
        ];

  mainCommon(devMiddlewares);
}
