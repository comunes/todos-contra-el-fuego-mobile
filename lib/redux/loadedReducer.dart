import 'actions.dart';

bool loadedReducer(isLoaded, action) {
  if (action is FetchYourLocationsSucceededAction) return true;
  return isLoaded;
}