import 'actions.dart';
import '../models/appState.dart';

AppState appReducer(AppState state, action) {
  if (action is FetchYourLocationsSucceededAction) {
    return state.copyWith(yourLocations: action.fetchedYourLocations);
  }
  return state;
}