import 'package:flutter/material.dart';

class BasicLocation  {
  final double lat;
  final double lon;
  final String description;

  BasicLocation({@required this.lat, @required this.lon, this.description});
}
