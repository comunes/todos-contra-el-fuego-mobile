import 'package:meta/meta.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:redux/redux.dart';
enum FireMapStatus { view, subscriptionConfirm, unsubscribe }

@immutable
class FireMapState {
  final FireMapStatus status;
  final YourLocation yourLocation;

  const FireMapState.initial(): this.status = FireMapStatus.view, this.yourLocation = null;

  FireMapState({this.status: FireMapStatus.view, this.yourLocation});

  FireMapState copyWith({FireMapStatus status, YourLocation yourLocation}) {
    return new FireMapState(
      yourLocation: yourLocation ?? this.yourLocation,
        status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is FireMapState &&
        runtimeType == other.runtimeType &&
        status == other.status &&
        yourLocation == other.yourLocation;

  @override
  int get hashCode =>
    status.hashCode ^
    yourLocation.hashCode;
}
