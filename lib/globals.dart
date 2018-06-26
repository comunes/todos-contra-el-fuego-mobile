library fires.globals;
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicLocation.dart';
import 'package:flutter/material.dart';

String gmapKey;
String firesApiKey;
String firesApiUrl;
final String appVersion = '0.0.1';

final Widget appMediumIcon = Image.asset('images/logo-200.png', width: 60.0, height: 60.0);
final Widget appIcon = Image.asset('images/logo-200.png', width: 24.0, height: 24.0);
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
final List<BasicLocation> yourLocations = [];
final GetIt getIt = new GetIt();
bool isDevelopment = false;
