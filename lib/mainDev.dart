import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'globals.dart' as globals;
import 'mainCommon.dart';

enum LogLevel { none, actions, full }

void main() {
  globals.isDevelopment = true;

  String onlyLogActionFormatter<State>(
    State state,
    dynamic action,
    DateTime timestamp,
  ) {
    return ">>>>> ${action.toString().replaceAll('Instance of ', '')}";
  }

  LogLevel logRedux = LogLevel.actions;

  List<Middleware> devMiddlewares = logRedux == LogLevel.none
      ? []
      : [LoggingMiddleware.printer(
          formatter: logRedux == LogLevel.full
              ? LoggingMiddleware.multiLineFormatter
              : onlyLogActionFormatter)];

  mainCommon(devMiddlewares);
}
