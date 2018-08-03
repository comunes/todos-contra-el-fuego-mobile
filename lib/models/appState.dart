import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'fireMapState.dart';
import 'user.dart';

export 'fireMapState.dart';

part 'appState.g.dart';

@immutable
@JsonSerializable(nullable: false)
class AppState extends Object with _$AppStateSerializerMixin {
  @JsonKey(ignore: true)
  final bool isLoading;
  @JsonKey(ignore: true)
  final bool isLoaded;
  @JsonKey(ignore: true)
  final String error;
  @JsonKey(ignore: true)
  final User user;
  @JsonKey(ignore: true)
  final String gmapKey;
  @JsonKey(ignore: true)
  final String serverUrl;
  @JsonKey(ignore: true)
  final String firesApiKey;
  @JsonKey(ignore: true)
  final String firesApiUrl;
  final List<YourLocation> yourLocations;
  final List<FireNotification> fireNotifications;
  @JsonKey(ignore: true)
  final int fireNotificationsUnread;
  @JsonKey(ignore: true)
  final FireMapState fireMapState;

  @JsonKey(ignore: true)
  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  AppState(
      {this.yourLocations: const <YourLocation>[],
      this.fireNotifications: const <FireNotification>[],
      this.fireNotificationsUnread: 0,
      this.user: const User.initial(),
      this.isLoading: false,
      this.isLoaded: false,
      this.error: null,
      this.gmapKey,
      this.firesApiKey,
      this.firesApiUrl,
      this.serverUrl,
      this.fireMapState: const FireMapState.initial()});

  AppState copyWith(
      {bool isLoading,
      bool isLoaded,
      String user,
      String error,
      String gmapKey,
      String firesApiKey,
      String serverUrl,
      String firesApiUrl,
      List<YourLocation> yourLocations,
      List<FireNotification> fireNotifications,
      int fireNotificationsUnread,
      FireMapState fireMapState}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        user: user ?? this.user,
        error: error ?? this.error,
        gmapKey: gmapKey ?? this.gmapKey,
        firesApiKey: firesApiKey ?? this.firesApiKey,
        firesApiUrl: firesApiUrl ?? this.firesApiUrl,
        serverUrl: serverUrl ?? this.serverUrl,
        yourLocations: yourLocations ?? this.yourLocations,
        fireNotifications: fireNotifications ?? this.fireNotifications,
        fireNotificationsUnread:
            fireNotificationsUnread ?? this.fireNotificationsUnread,
        fireMapState: fireMapState ?? this.fireMapState);
  }

  @override
  String toString() {
    return 'AppState{\nuser: ${user}\nisLoading: $isLoading\nisLoaded: $isLoaded\napiKey: ${ellipse(
      firesApiKey,
      8)}\napiUrl: ${firesApiUrl}\nserverUrl: ${serverUrl}\nfireMapState: $fireMapState\nyourLocations count: ${yourLocations
      .length}\nunread notif: ${fireNotificationsUnread}\nfireNotifications: ${fireNotifications}\nyourLocations: ${yourLocations}}';
  }
}

typedef void AddYourLocationFunction(YourLocation loc);
typedef void DeleteYourLocationFunction(YourLocation loc);
typedef void OnRefreshYourLocationsFunction(Completer<Null> callback);
typedef void ToggleSubscriptionFunction(YourLocation loc);
typedef void OnLocationTapFunction(YourLocation loc);
typedef void OnSubscribeFunction(YourLocation loc);
typedef void OnSubscribeDistanceChangeFunction(YourLocation loc);
typedef void OnUnSubscribeFunction(YourLocation loc);
typedef void OnSubscribeConfirmedFunction(YourLocation loc);
typedef void OnLocationEdit(YourLocation loc);
typedef void OnLocationEditing(YourLocation loc);
typedef void OnLocationEditConfirm(YourLocation loc);
typedef void OnLocationEditCancel(YourLocation loc);
typedef void TapFireNotificationFunction(FireNotification notif);
// typedef void OnReceivedFireNotificationFunction(FireNotification notif);
typedef void DeleteFireNotificationFunction(FireNotification notif);
typedef void DeleteAllFireNotificationFunction();

// unused
// typedef void UpdateYourLocationFunction(ObjectId id, YourLocation loc);
