import 'package:flutter/material.dart';

class BasicLocation  {
  final double lat;
  final double lon;
  final String description;

  static BasicLocation noLocation = new BasicLocation(lat:0.0, lon:0.0);

  BasicLocation({@required this.lat, @required this.lon, this.description});

  BasicLocation.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
      lon = json['lon'],
      description = json['description']
  ;

  Map<String, dynamic> toJson() =>
    {
      'lat': lat,
      'lon': lon,
      'description': description,
    };

}
