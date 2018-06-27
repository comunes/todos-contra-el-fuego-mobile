import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'fireMapState.dart';
import 'yourLocation.dart';
import 'user.dart';
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
  final String firesApiKey;
  @JsonKey(ignore: true)
  final String firesApiUrl;
  final List<YourLocation> yourLocations;
  @JsonKey(ignore: true)
  final FireMapState fireMapState;

  @JsonKey(ignore: true)
  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  AppState(
      {this.yourLocations : const <YourLocation>[],
        this.user: const User.initial(),
      this.isLoading: false,
      this.isLoaded: false,
      this.error: null,
      this.gmapKey,
      this.firesApiKey,
      this.firesApiUrl,
      this.fireMapState: const FireMapState.initial()});

  AppState copyWith(
      {bool isLoading,
      bool isLoaded,
      String user,
      String error,
      String gmapKey,
      String firesApiKey,
      String firesApiUrl,
      List<YourLocation> yourLocations,
      FireMapState fireMapState}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        user: user ?? this.user,
        error: error ?? this.error,
        gmapKey: gmapKey ?? this.gmapKey,
        firesApiKey: firesApiKey ?? this.firesApiKey,
        firesApiUrl: firesApiUrl ?? this.firesApiUrl,
        yourLocations: yourLocations ?? this.yourLocations,
        fireMapState: fireMapState ?? this.fireMapState);
  }

  @override
  String toString() {
    return 'AppState{\nuser: ${user}\nisLoading: $isLoading\nisLoaded: $isLoaded\napiKey: ${ellipse(firesApiKey, 8)}\napiUrl: ${ellipse(firesApiUrl, 8)}\nyourLocations: ${yourLocations}';
  }
}
