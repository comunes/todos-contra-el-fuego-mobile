// Copyright (c) 2018, Comunes Association.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fireNotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireNotification _$FireNotificationFromJson(Map<String, dynamic> json) =>
    new FireNotification(
        id: _objectIdFromJson(json['id'] as String),
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        description: json['description'] as String,
        when: DateTime.parse(json['when'] as String));

abstract class _$FireNotificationSerializerMixin {
  ObjectId get id;
  double get lat;
  double get lon;
  String get description;
  DateTime get when;
  Map<String, dynamic> toJson() => new _$FireNotificationJsonMapWrapper(this);
}

class _$FireNotificationJsonMapWrapper extends $JsonMapWrapper {
  final _$FireNotificationSerializerMixin _v;
  _$FireNotificationJsonMapWrapper(this._v);

  @override
  Iterable<String> get keys =>
      const ['id', 'lat', 'lon', 'description', 'when'];

  @override
  dynamic operator [](Object key) {
    if (key is String) {
      switch (key) {
        case 'id':
          return _objectIdToJson(_v.id);
        case 'lat':
          return _v.lat;
        case 'lon':
          return _v.lon;
        case 'description':
          return _v.description;
        case 'when':
          return _v.when.toIso8601String();
      }
    }
    return null;
  }
}
