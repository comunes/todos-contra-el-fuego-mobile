import 'package:redux/redux.dart';

import '../models/fireMapState.dart';
import 'actions.dart';

final fireMapReducer = combineReducers<FireMapState>([
  new TypedReducer<FireMapState, ShowYourLocationMapAction>(
      _showYourLocationMap),
  new TypedReducer<FireMapState, UpdateYourLocationMapStatsAction>(
      _updateYourLocationMapStats),
  new TypedReducer<FireMapState, SubscribeAction>(_subscribeYourLocationMap),
  new TypedReducer<FireMapState, SubscribeConfirmAction>(
      _subscribeConfirmYourLocationMap),
  new TypedReducer<FireMapState, UnSubscribeAction>(
      _unsubscribeYourLocationMap),
]);

FireMapState _updateYourLocationMapStats(
    FireMapState state, UpdateYourLocationMapStatsAction action) {
  return state.copyWith(
      numFires: action.numFires,
      fires: action.fires,
      falsePos: action.falsePos,
      industries: action.industries);
}

FireMapState _showYourLocationMap(
    FireMapState state, ShowYourLocationMapAction action) {
  return state.copyWith(
      status: action.loc.subscribed
          ? FireMapStatus.unsubscribe
          : FireMapStatus.view,
      yourLocation: action.loc);
}

FireMapState _subscribeYourLocationMap(
    FireMapState state, SubscribeAction action) {
  return state.copyWith(status: FireMapStatus.subscriptionConfirm);
}

FireMapState _subscribeConfirmYourLocationMap(
    FireMapState state, SubscribeConfirmAction action) {
  return state.copyWith(status: FireMapStatus.unsubscribe);
}

FireMapState _unsubscribeYourLocationMap(
    FireMapState state, UnSubscribeAction action) {
  return state.copyWith(status: FireMapStatus.view);
}
