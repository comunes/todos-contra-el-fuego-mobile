import 'package:fires_flutter/models/yourLocation.dart';
import 'package:meta/meta.dart';

enum FireMapStatus { view, subscriptionConfirm, unsubscribe }

@immutable
class FireMapState {
  final FireMapStatus status;
  final int numFires;
  final List<dynamic> fires;
  final List<dynamic> falsePos;
  final List<dynamic> industries;
  final YourLocation yourLocation;

  const FireMapState.initial()
      : this.status = FireMapStatus.view,
        this.yourLocation = null,
        this.numFires = 0,
        this.fires = const [],
        this.falsePos = const [],
        this.industries = const [];

  FireMapState(
      {this.status: FireMapStatus.view,
      this.yourLocation,
      this.numFires,
      this.fires,
      this.falsePos,
      this.industries});

  FireMapState copyWith({
    FireMapStatus status,
    YourLocation yourLocation,
    int numFires,
    List<dynamic> fires,
    List<dynamic> falsePos,
    List<dynamic> industries,
  }) {
    return new FireMapState(
        yourLocation: yourLocation ?? this.yourLocation,
        numFires: numFires ?? this.numFires,
        fires: fires ?? this.fires,
        falsePos: falsePos ?? this.falsePos,
        industries: industries ?? this.industries,
        status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FireMapState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          numFires == other.numFires &&
          fires == other.fires &&
          falsePos == other.falsePos &&
          industries == other.industries &&
          yourLocation == other.yourLocation;

  @override
  int get hashCode =>
      status.hashCode ^
      numFires.hashCode ^
      fires.hashCode ^
      falsePos.hashCode ^
      industries.hashCode ^
      yourLocation.hashCode;

  @override
  String toString() {
    return 'FireMapState{status: $status, numFires: $numFires, fires: ${fires
      .length}, falsePos: ${falsePos.length}, industries: ${industries
      .length}, yourLocation: $yourLocation}';
  }
}
