import 'package:fires_flutter/models/yourLocation.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

final yourLocationsReducer = combineReducers<List<YourLocation>>([
  new TypedReducer<List<YourLocation>, AddYourLocationAction>(_addYourLocation),
  new TypedReducer<List<YourLocation>, DeleteYourLocationAction>(
      _deleteYourLocation),
  new TypedReducer<List<YourLocation>, UpdateYourLocationAction>(
      _updateYourLocation),

  /*  new TypedReducer<List<YourLocation>, ToggleSubscriptionAction>(_toggleSubscriptionAction),
  new TypedReducer<List<YourLocation>, SubscribeAction>(_setLoadedYourLocations),
  new TypedReducer<List<YourLocation>, UnSubscribeAction>(_setNoYourLocations), */
]);

List<YourLocation> _addYourLocation(
    List<YourLocation> yourLocations, AddYourLocationAction action) {
  return new List.from(yourLocations)..add(action.loc);
}

List<YourLocation> _deleteYourLocation(
    List<YourLocation> yourLocations, DeleteYourLocationAction action) {
  return yourLocations
      .where((yourLocation) => yourLocation.id != action.id)
      .toList();
}

List<YourLocation> _updateYourLocation(
    List<YourLocation> yourLocations, UpdateYourLocationAction action) {
  return yourLocations
      .map((yourLocation) =>
          yourLocation.id == action.id ? action.loc : yourLocation)
      .toList();
}
/*
List<YourLocation> _toggleSubscriptionAction(List<YourLocation> yourLocations, UpdateYourLocationAction action) {
  return yourLocations
    .map((yourLocation) => yourLocation.id == action.id ? action.loc : yourLocation)
    .toList();
}

List<YourLocation> _setLoadedYourLocations(List<YourLocation> yourLocations, YourLocationsLoadedAction action) {
  return action.yourLocations;
}

List<YourLocation> _setNoYourLocations(List<YourLocation> yourLocations, YourLocationsNotLoadedAction action) {
  return [];
}
*/
