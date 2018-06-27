import 'package:bson_objectid/bson_objectid.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'dart:convert';

part 'yourLocation.g.dart';

_objectIdFromJson(String json) {
  return new ObjectId.fromHexString(json);
}

_objectIdToJson(ObjectId o) {
  return o.toString();
}

@JsonSerializable(nullable: false)
class YourLocation extends Object with _$YourLocationSerializerMixin {
  @JsonKey(toJson: _objectIdToJson, fromJson: _objectIdFromJson)
  ObjectId id;
  final double lat;
  final double lon;
  String description;
  bool subscribed;

  factory YourLocation.fromJson(Map<String, dynamic> json) =>
      _$YourLocationFromJson(json);

  static YourLocation noLocation = new YourLocation(lat: 0.0, lon: 0.0);

  YourLocation(
      {this.id,
      @required this.lat,
      @required this.lon,
      this.description,
      this.subscribed: false}) {
    if (this.description == null)
      this.description = 'Position: ${this.lat}, ${this.lon}';
    if (this.id == null) this.id = new ObjectId();
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
          subscribed == other.subscribed;

  @override
  int get hashCode =>
      id.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      description.hashCode ^
      subscribed.hashCode;
}
