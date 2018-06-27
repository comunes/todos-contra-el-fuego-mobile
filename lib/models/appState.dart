import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'fireMapState.dart';
import 'yourLocation.dart';

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
  final String userId;
  final String token;
  final List<YourLocation> yourLocations;
  @JsonKey(ignore: true)
  final FireMapState fireMapState;

  @JsonKey(ignore: true)
  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  AppState(
      {this.yourLocations = const [],
      this.userId,
      this.token,
      this.isLoading: false,
      this.isLoaded: false,
      this.error: null,
      this.fireMapState: const FireMapState.initial()});

  AppState copyWith(
      {bool isLoading,
      bool isLoaded,
      String userId,
      String token,
      String error,
      List<YourLocation> yourLocations,
      FireMapState fireMapState}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        userId: userId ?? this.userId,
        token: token ?? this.token,
        error: error ?? this.error,
        yourLocations: yourLocations ?? this.yourLocations,
        fireMapState: fireMapState ?? this.fireMapState);
  }

  @override
  String toString() {
    return 'AppState{\nuserId: $userId\ntoken: $token\nisLoading: $isLoading\nisLoaded: $isLoaded\nYourLocations: $yourLocations}';
  }
}
