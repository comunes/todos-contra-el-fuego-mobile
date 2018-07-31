import 'package:bson_objectid/bson_objectid.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redux/src/store.dart';

import '../genericMap.dart';
import '../objectIdUtils.dart';
import '../redux/actions.dart';

part 'fireNotification.g.dart';

@JsonSerializable(nullable: false)
class FireNotification extends Object with _$FireNotificationSerializerMixin {
  @JsonKey(toJson: objectIdToJson, fromJson: objectIdFromJson)
  ObjectId id;
  final double lat;
  final double lon;
  final String description;
  final DateTime when;
  final String sealed;
  @JsonKey(toJson: objectIdToJson, fromJson: objectIdFromJson)
  final ObjectId subsId;
  final bool read;

  factory FireNotification.fromJson(Map<String, dynamic> json) =>
      _$FireNotificationFromJson(json);

  FireNotification(
      {this.id,
      @required this.lat,
      @required this.lon,
      @required this.description,
      @required this.when,
      @required this.read,
      @required this.sealed,
      @required this.subsId}) {
    if (this.id == null) this.id = new ObjectId();
  }

  FireNotification copyWith(
      {id, lat, lon, description, read, when, sealed, subsId}) {
    return new FireNotification(
        id: id ?? this.id,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        read: read ?? this.read,
        description: description ?? this.description,
        sealed: sealed ?? this.sealed,
        subsId: subsId ?? this.subsId,
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
          sealed == other.sealed &&
          subsId == other.subsId &&
          when == other.when;

  @override
  int get hashCode =>
      id.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      description.hashCode ^
      when.hashCode ^
      read.hashCode ^
      sealed.hashCode ^
      subsId.hashCode;

  @override
  String toString() {
    return 'FireNotification {id: $id, lat: $lat, lon: $lon, when: $when, read: $read, subsId: $subsId, sealed ${ellipse(
      sealed)}';
  }

  static final Map<String, Route<Null>> routes = <String, Route<Null>>{};

  Route<Null> getRoute(Store store) {
    final String routeName = '/fire/${id}';
    return routes.putIfAbsent(
      routeName,
      () => new MaterialPageRoute<Null>(
            settings: new RouteSettings(name: routeName),
            builder: (BuildContext context) {
              store.dispatch(new ShowFireNotificationMapAction(this));
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new genericMap()));
            },
          ),
    );
  }
}
