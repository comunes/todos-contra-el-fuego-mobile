library fires.globals;
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicLocation.dart';

String gmapKey;
String appName = 'All Against Fire!';
Future<SharedPreferences> prefs = SharedPreferences.getInstance();
final List<BasicLocation> yourLocations = [];
final GetIt getIt = new GetIt();
