import 'package:fires_flutter/models/yourLocation.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

final yourLocationsReducer = combineReducers<List<YourLocation>>([
  new TypedReducer<List<YourLocation>, AddedYourLocationAction>(
      _addedYourLocation),
  new TypedReducer<List<YourLocation>, DeletedYourLocationAction>(
      _deletedYourLocation),
  new TypedReducer<List<YourLocation>, UpdateYourLocationAction>(
      _updateYourLocation),
  new TypedReducer<List<YourLocation>, ToggledSubscriptionAction>(
      _toggledSubscriptionAction)
]);

List<YourLocation> _addedYourLocation(
    List<YourLocation> yourLocations, AddedYourLocationAction action) {
  return new List.from(yourLocations)..add(action.loc);
}

List<YourLocation> _deletedYourLocation(
    List<YourLocation> yourLocations, DeletedYourLocationAction action) {
  return yourLocations
      .where((yourLocation) => yourLocation.id != action.id)
      .toList();
}

List<YourLocation> _updateYourLocation(
    List<YourLocation> yourLocations, UpdateYourLocationAction action) {
  return yourLocations
      .map((yourLocation) =>
          yourLocation.id == action.loc.id ? action.loc : yourLocation)
      .toList();
}

List<YourLocation> _toggledSubscriptionAction(
    List<YourLocation> yourLocations, ToggledSubscriptionAction action) {
  return yourLocations
      .map((yourLocation) =>
          yourLocation.id == action.loc.id ? action.loc : yourLocation)
      .toList();
}
