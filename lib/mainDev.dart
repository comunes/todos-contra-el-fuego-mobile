import 'package:redux_logging/redux_logging.dart';

import 'globals.dart' as globals;
import 'mainCommon.dart';

void main() {
  globals.isDevelopment = true;

  List devMiddlewares = [
    new LoggingMiddleware(formatter: LoggingMiddleware.multiLineFormatter)
  ];

  mainCommon(devMiddlewares);
}
