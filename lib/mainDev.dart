import 'package:redux_logging/redux_logging.dart';

import 'globals.dart' as globals;
import 'mainCommon.dart';
import 'package:redux/redux.dart';

void main() {
  globals.isDevelopment = true;

  List<Middleware> devMiddlewares = [
    LoggingMiddleware.printer(formatter: LoggingMiddleware.multiLineFormatter)
  ];

  mainCommon(devMiddlewares);
}
