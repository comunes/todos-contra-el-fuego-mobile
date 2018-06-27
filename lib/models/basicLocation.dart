import 'package:flutter/material.dart';

class BasicLocation extends Comparable<BasicLocation> {
  final double lat;
  final double lon;
  String description;

//  static BasicLocation noLocation = new BasicLocation(lat: 0.0, lon: 0.0);

  BasicLocation({@required this.lat, @required this.lon, this.description}) {
    if (this.description == null)
      this.description = 'Position: ${this.lat}, ${this.lon}';
  }

  int compareTo(BasicLocation other) {
    return lat == other.lat && lon == other.lon ? 1 : 0;
  }

  bool operator ==(o) => o is BasicLocation && o.lat == lat && o.lon == lon;

  int get hashCode {
    int hash = 1;
    hash = hash * 17 + lat.hashCode;
    hash = hash * 31 + lon.hashCode;
    return hash;
  }

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
