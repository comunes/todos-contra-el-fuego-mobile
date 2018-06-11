import 'package:flutter/material.dart';

class BasicLocation extends Comparable<BasicLocation> {
  final double lat;
  final double lon;
  String description;

  static BasicLocation noLocation = new BasicLocation(lat: 0.0, lon: 0.0);

  BasicLocation({@required this.lat, @required this.lon, this.description});

  int compareTo(BasicLocation other) {
    return lat == other.lat && lon == other.lon ? 1 : 0;
  }

  bool operator ==(o) => o is BasicLocation && o.lat == lat && o.lon == lon;

  BasicLocation.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'description': description,
      };
}
