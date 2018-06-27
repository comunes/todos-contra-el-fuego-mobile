// Copyright (c) 2018, Comunes Association.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yourLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YourLocation _$YourLocationFromJson(Map<String, dynamic> json) =>
    new YourLocation(
        id: _objectIdFromJson(json['id'] as String),
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        description: json['description'] as String,
        subscribed: json['subscribed'] as bool);

abstract class _$YourLocationSerializerMixin {
  ObjectId get id;
  double get lat;
  double get lon;
  String get description;
  bool get subscribed;
  Map<String, dynamic> toJson() => new _$YourLocationJsonMapWrapper(this);
}

class _$YourLocationJsonMapWrapper extends $JsonMapWrapper {
  final _$YourLocationSerializerMixin _v;
  _$YourLocationJsonMapWrapper(this._v);

  @override
  Iterable<String> get keys =>
      const ['id', 'lat', 'lon', 'description', 'subscribed'];

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
        case 'subscribed':
          return _v.subscribed;
      }
    }
    return null;
  }
}
