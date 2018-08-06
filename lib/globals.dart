library fires.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

final String appVersion = '1.3';

final Widget appMediumIcon =
    Image.asset('images/logo-200.png', width: 60.0, height: 60.0);
final Widget appIcon =
    Image.asset('images/logo-200.png', width: 24.0, height: 24.0);
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
bool isDevelopment = false;
