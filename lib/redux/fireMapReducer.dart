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
  new TypedReducer<FireMapState, EditYourLocationAction>(_editYourLocationMap),
  new TypedReducer<FireMapState, EditConfirmYourLocationAction>(
      _editConfirmYourLocationMap),
  new TypedReducer<FireMapState, EditingYourLocationAction>(
      _editingYourLocationMap),
  new TypedReducer<FireMapState, EditCancelYourLocationAction>(
      _editCancelYourLocationMap),
  new TypedReducer<FireMapState, UpdateYourLocationMapAction>(
      _updateYourLocationMap)
]);

FireMapState _updateYourLocationMapStats(
    FireMapState state, UpdateYourLocationMapStatsAction action) {
  return state.copyWith(
      numFires: action.numFires,
      fires: action.fires,
      falsePos: action.falsePos,
      industries: action.industries);
}

FireMapState _updateYourLocationMap(
    FireMapState state, UpdateYourLocationMapAction action) {
  return state.copyWith(yourLocation: action.loc);
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

FireMapState _editYourLocationMap(
    FireMapState state, EditYourLocationAction action) {
  return state.copyWith(status: FireMapStatus.edit);
}

FireMapState _editingYourLocationMap(
    FireMapState state, EditingYourLocationAction action) {
  return state.copyWith(yourLocation: action.loc);
}

FireMapState _editConfirmYourLocationMap(
    FireMapState state, EditConfirmYourLocationAction action) {
  return state.copyWith(status: restoreStatusAfterSave(action.loc));
}

FireMapState _editCancelYourLocationMap(
    FireMapState state, EditCancelYourLocationAction action) {
  return state.copyWith(
      status: restoreStatusAfterSave(action.loc), yourLocation: action.loc);
}

FireMapStatus restoreStatusAfterSave(loc) =>
    loc.subscribed ? FireMapStatus.unsubscribe : FireMapStatus.view;
