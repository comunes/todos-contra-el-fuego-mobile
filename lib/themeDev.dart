import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData devFiresTheme = _buildFiresTheme();

ThemeData _buildFiresTheme() {
  final ThemeData base = ThemeData.light(); // light or dark
  return base.copyWith(
    accentColor: fires900,
    primaryColor: Colors.pink,
    buttonColor: fires900,
    scaffoldBackgroundColor: firesSurfaceWhite,
    cardColor: firesBackgroundWhite,
    textSelectionColor: fires300,
    errorColor: firesErrorRed,

    //TODO: Add the text themes (103)
    //TODO: Add the icon themes (103)
    //TODO: Decorate the inputs (103)
  );
}
