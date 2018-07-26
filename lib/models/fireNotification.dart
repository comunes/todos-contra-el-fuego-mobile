import 'package:bson_objectid/bson_objectid.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fireNotification.g.dart';

_objectIdFromJson(String json) {
  return new ObjectId.fromHexString(json);
}

_objectIdToJson(ObjectId o) {
  return o.toString();
}

@JsonSerializable(nullable: false)
class FireNotification extends Object with _$FireNotificationSerializerMixin {
  @JsonKey(toJson: _objectIdToJson, fromJson: _objectIdFromJson)
  ObjectId id;
  final double lat;
  final double lon;
  final String description;
  final DateTime when;
  final bool read;

  factory FireNotification.fromJson(Map<String, dynamic> json) => _$FireNotificationFromJson(json);

  FireNotification({this.id, @required this.lat, @required this.lon, @required this.description, @required this.when, @required this.read}) {
    if (this.id == null) this.id = new ObjectId();
  }

  FireNotification copyWith({id, lat, lon, description, read, when}) {
    return new FireNotification(
        id: id ?? this.id,
        lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      read: read ?? this.read,
        description: description ?? this.description,
        when: when ?? this.when);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FireNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lat == other.lat &&
        lon == other.lon &&
        read == other.read &&
          description == other.description &&
          when == other.when;

  @override
  int get hashCode => id.hashCode ^ lat.hashCode ^ lon.hashCode ^ description.hashCode ^ when.hashCode ^ read.hashCode;

  @override
  String toString() {
    return 'FireNotification {id: $id, lat: $lat, lon: $lon, description: $description, when: $when, read: $read}';
  }
}
