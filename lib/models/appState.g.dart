// Copyright (c) 2018, Comunes Association.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => new AppState(
    yourLocations: (json['yourLocations'] as List)
        .map((e) => new YourLocation.fromJson(e as Map<String, dynamic>))
        .toList(),
    fireNotifications: (json['fireNotifications'] as List)
        .map((e) => new FireNotification.fromJson(e as Map<String, dynamic>))
        .toList());

abstract class _$AppStateSerializerMixin {
  List<YourLocation> get yourLocations;
  List<FireNotification> get fireNotifications;
  Map<String, dynamic> toJson() => new _$AppStateJsonMapWrapper(this);
}

class _$AppStateJsonMapWrapper extends $JsonMapWrapper {
  final _$AppStateSerializerMixin _v;
  _$AppStateJsonMapWrapper(this._v);

  @override
  Iterable<String> get keys => const ['yourLocations', 'fireNotifications'];

  @override
  dynamic operator [](Object key) {
    if (key is String) {
      switch (key) {
        case 'yourLocations':
          return _v.yourLocations;
        case 'fireNotifications':
          return _v.fireNotifications;
      }
    }
    return null;
  }
}
