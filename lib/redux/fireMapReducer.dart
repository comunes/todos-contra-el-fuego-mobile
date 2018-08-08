import 'package:redux/redux.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import '../models/fireMapState.dart';
import 'actions.dart';

final fireMapReducer = combineReducers<FireMapState>([
  new TypedReducer<FireMapState, ShowYourLocationMapAction>(
      _showYourLocationMap),
  new TypedReducer<FireMapState, ShowFireNotificationMapAction>(
    _showFireNotificationMap),
  new TypedReducer<FireMapState, UpdateFireMapStatsAction>(
      _updateYourLocationMapStats),
  new TypedReducer<FireMapState, SubscribeAction>(_subscribeYourLocationMap),
  new TypedReducer<FireMapState, SubscribeConfirmAction>(
      _subscribeConfirmYourLocationMap),
  new TypedReducer<FireMapState, UnSubscribeAction>(
      _unsubscribeYourLocationMap),
  new TypedReducer<FireMapState, EditYourLocationAction>(_editYourLocationMap),
  new TypedReducer<FireMapState, EditConfirmYourLocationAction>(
      _editConfirmYourLocationMap),
  new TypedReducer<FireMapState, EditCancelYourLocationAction>(
      _editCancelYourLocationMap),
  new TypedReducer<FireMapState, ToggleMapLayerAction>(
    _toggleMapLayer),
  new TypedReducer<FireMapState, UpdateYourLocationMapAction>(
      _updateYourLocationMap)
]);

FireMapState _updateYourLocationMapStats(
    FireMapState state, UpdateFireMapStatsAction action) {
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
      yourLocation: action.loc, fireNotication: null);
}

FireMapState _showFireNotificationMap(
    FireMapState state, ShowFireNotificationMapAction action) {
  // TODO: use here you real location?
  YourLocation pseudoLoc = new YourLocation(lat: action.notif.lat, lon: action.notif.lon, description: action.notif.description);
  return state.copyWith(
      status: FireMapStatus.viewFireNotification, yourLocation: pseudoLoc, fireNotication: action.notif);
}

FireMapState _subscribeYourLocationMap(
    FireMapState state, SubscribeAction action) {
  return state.copyWith(status: FireMapStatus.subscriptionConfirm);
}

FireMapState _subscribeConfirmYourLocationMap(
    FireMapState state, SubscribeConfirmAction action) {
  return state.copyWith(
      status: FireMapStatus.unsubscribe, yourLocation: action.loc);
}

FireMapState _unsubscribeYourLocationMap(
    FireMapState state, UnSubscribeAction action) {
  return state.copyWith(status: FireMapStatus.view, yourLocation: action.loc);
}

FireMapState _editYourLocationMap(
    FireMapState state, EditYourLocationAction action) {
  return state.copyWith(status: FireMapStatus.edit);
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

FireMapState _toggleMapLayer(
  FireMapState state, ToggleMapLayerAction action) {
  FireMapLayer currentLayer = state.layer;
  List<FireMapLayer> list = FireMapLayer.values;
  int currentPos = list.indexOf(currentLayer);
  currentPos++;
  FireMapLayer next = list.elementAt(currentPos >= list.length ? 0: currentPos);
  return state.copyWith(layer: next);
}