import 'package:bson_objectid/bson_objectid.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fires_flutter/objectIdUtils.dart';

part 'yourLocation.g.dart';



@JsonSerializable(nullable: false)
class YourLocation extends Object with _$YourLocationSerializerMixin {
  @JsonKey(toJson: objectIdToJson, fromJson: objectIdFromJson)
  ObjectId id;
  final double lat;
  final double lon;
  String description;
  bool subscribed;
  int distance;
  int currentNumFires;

  factory YourLocation.fromJson(Map<String, dynamic> json) =>
      _$YourLocationFromJson(json);

  static YourLocation noLocation = new YourLocation(lat: 0.0, lon: 0.0);
static const int withoutStats = null;
  YourLocation(
      {this.id,
      @required this.lat,
      @required this.lon,
      this.description,
      this.distance: 10,
        int currentNumFires: withoutStats,
      this.subscribed: false}) {
    if (this.description == null)
      this.description = 'Position: ${this.lat}, ${this.lon}';
    if (this.id == null) this.id = new ObjectId();
  }

  YourLocation copyWith(
      {id,
      lat,
      lon,
      description,
      distance,
        currentNumFires,
      subscribed}) {
    return new YourLocation(
    id: id?? this.id,
      lat: lat?? this.lat,
      lon: lon?? this.lon,
      description: description?? this.description,
      distance: distance?? this.distance,
      currentNumFires: currentNumFires ?? this.currentNumFires,
      subscribed: subscribed?? this.subscribed
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YourLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lat == other.lat &&
          lon == other.lon &&
          description == other.description &&
          subscribed == other.subscribed &&
        currentNumFires == other.currentNumFires &&
          distance == other.distance;

  @override
  int get hashCode =>
      id.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      description.hashCode ^
      subscribed.hashCode ^
      currentNumFires.hashCode ^
      distance.hashCode;

  @override
  String toString() {
    return 'YourLocation {id: $id, lat: $lat, lon: $lon, description: $description, subscribed: $subscribed, distance: $distance, currentNumFires: $currentNumFires}';
  }
}
