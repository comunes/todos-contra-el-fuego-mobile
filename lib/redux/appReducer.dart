import 'actions.dart';
import '../models/appState.dart';

AppState appReducer(AppState state, action) {
  if (action is FetchYourLocationsSucceededAction) {
    return state.copyWith(yourLocations: action.fetchedYourLocations);
  }
  if (action is FetchFireNotificationsSucceededAction) {
    return state.copyWith(fireNotifications: action.fetchedFireNotifications);
  }
  return state;
}