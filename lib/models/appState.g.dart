// Copyright (c) 2018, Comunes Association.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => new AppState(
    yourLocations: (json['yourLocations'] as List)
        .map((e) => new YourLocation.fromJson(e as Map<String, dynamic>))
        .toList());

abstract class _$AppStateSerializerMixin {
  List<YourLocation> get yourLocations;
  Map<String, dynamic> toJson() => new _$AppStateJsonMapWrapper(this);
}

class _$AppStateJsonMapWrapper extends $JsonMapWrapper {
  final _$AppStateSerializerMixin _v;
  _$AppStateJsonMapWrapper(this._v);

  @override
  Iterable<String> get keys => const ['yourLocations'];

  @override
  dynamic operator [](Object key) {
    if (key is String) {
      switch (key) {
        case 'yourLocations':
          return _v.yourLocations;
      }
    }
    return null;
  }
}
