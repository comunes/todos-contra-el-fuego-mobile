// Copyright (c) 2018, Comunes Association.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fireNotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireNotification _$FireNotificationFromJson(Map<String, dynamic> json) =>
    new FireNotification(
        id: objectIdFromJson(json['id'] as String),
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        description: json['description'] as String,
        when: DateTime.parse(json['when'] as String),
        read: json['read'] as bool,
        sealed: json['sealed'] as String,
        subsId: objectIdFromJson(json['subsId'] as String));

abstract class _$FireNotificationSerializerMixin {
  ObjectId get id;
  double get lat;
  double get lon;
  String get description;
  DateTime get when;
  String get sealed;
  ObjectId get subsId;
  bool get read;
  Map<String, dynamic> toJson() => new _$FireNotificationJsonMapWrapper(this);
}

class _$FireNotificationJsonMapWrapper extends $JsonMapWrapper {
  final _$FireNotificationSerializerMixin _v;
  _$FireNotificationJsonMapWrapper(this._v);

  @override
  Iterable<String> get keys => const [
        'id',
        'lat',
        'lon',
        'description',
        'when',
        'sealed',
        'subsId',
        'read'
      ];

  @override
  dynamic operator [](Object key) {
    if (key is String) {
      switch (key) {
        case 'id':
          return objectIdToJson(_v.id);
        case 'lat':
          return _v.lat;
        case 'lon':
          return _v.lon;
        case 'description':
          return _v.description;
        case 'when':
          return _v.when.toIso8601String();
        case 'sealed':
          return _v.sealed;
        case 'subsId':
          return objectIdToJson(_v.subsId);
        case 'read':
          return _v.read;
      }
    }
    return null;
  }
}
