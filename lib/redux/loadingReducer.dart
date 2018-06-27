import 'actions.dart';
bool loadingReducer(isLoading, action) {
  if (action is FetchYourLocationsAction) return true;
  return isLoading;
}