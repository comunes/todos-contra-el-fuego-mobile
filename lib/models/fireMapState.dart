import 'package:meta/meta.dart';

enum FireMapOperation { view, subscriptionConfirm, unsubscribe }

@immutable
class FireMapState {
  final FireMapOperation currentOperation;

  const FireMapState.initial(): this.currentOperation = FireMapOperation.view;

  FireMapState({this.currentOperation: FireMapOperation.view});

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is FireMapState &&
        runtimeType == other.runtimeType &&
        currentOperation == other.currentOperation;

  @override
  int get hashCode => currentOperation.hashCode;

  FireMapState copyWith({FireMapOperation currentOperation}) {
    return new FireMapState(
        currentOperation: currentOperation ?? this.currentOperation);
  }
}
