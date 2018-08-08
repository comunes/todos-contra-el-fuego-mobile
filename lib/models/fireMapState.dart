import 'package:fires_flutter/models/fireNotification.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:meta/meta.dart';

enum FireMapStatus {
  view,
  subscriptionConfirm,
  unsubscribe,
  edit,
  viewFireNotification
}
enum FireMapLayer { osmcGrey, esriSatellite, osmc, esri, esriTerrain }

@immutable
class FireMapState {
  final FireMapStatus status;
  final FireMapLayer layer;
  final int numFires;
  final FireNotification fireNotification;
  final List<dynamic> fires;
  final List<dynamic> falsePos;
  final List<dynamic> industries;
  final YourLocation yourLocation;

  const FireMapState.initial()
      : this.status = FireMapStatus.view,
        this.layer = FireMapLayer.osmcGrey,
        this.yourLocation = null,
        this.fireNotification = null,
        this.numFires = 0,
        this.fires = const [],
        this.falsePos = const [],
        this.industries = const [];

  FireMapState(
      {this.status: FireMapStatus.view,
      this.layer: FireMapLayer.osmcGrey,
      this.yourLocation,
      this.numFires,
      this.fires,
      this.fireNotification,
      this.falsePos,
      this.industries});

  FireMapState copyWith({
    FireMapStatus status,
    FireMapLayer layer,
    YourLocation yourLocation,
    FireNotification fireNotication,
    int numFires,
    List<dynamic> fires,
    List<dynamic> falsePos,
    List<dynamic> industries,
  }) {
    return new FireMapState(
        yourLocation: yourLocation ?? this.yourLocation,
        fireNotification: fireNotication ?? this.fireNotification,
        numFires: numFires ?? this.numFires,
        fires: fires ?? this.fires,
        falsePos: falsePos ?? this.falsePos,
        industries: industries ?? this.industries,
        layer: layer ?? this.layer,
        status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FireMapState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          layer == other.layer &&
          numFires == other.numFires &&
          fireNotification == other.fireNotification &&
          fires == other.fires &&
          falsePos == other.falsePos &&
          industries == other.industries &&
          yourLocation == other.yourLocation;

  @override
  int get hashCode =>
      status.hashCode ^
      layer.hashCode ^
      numFires.hashCode ^
      fireNotification.hashCode ^
      fires.hashCode ^
      falsePos.hashCode ^
      industries.hashCode ^
      yourLocation.hashCode;

  @override
  String toString() {
    return 'FireMapState{status: $status, layer: $layer, numFires: $numFires, fires: ${fires
      .length}, falsePos: ${falsePos.length}, industries: ${industries
      .length}, yourLocation: $yourLocation, fireNotification: $fireNotification}';
  }
}
