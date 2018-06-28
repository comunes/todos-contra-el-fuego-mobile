import 'package:redux_logging/redux_logging.dart';

import 'globals.dart' as globals;
import 'mainCommon.dart';
import 'package:redux/redux.dart';

void main() {
  globals.isDevelopment = true;
  var logRedux = true;

  List<Middleware> devMiddlewares = logRedux ? [
    LoggingMiddleware.printer(formatter: LoggingMiddleware.multiLineFormatter)
  ] : [];

  mainCommon(devMiddlewares);
}
