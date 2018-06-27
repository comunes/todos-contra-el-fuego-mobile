import '../models/appState.dart';
import 'errorReducer.dart';
import 'fireMapReducer.dart';
import 'loadedReducer.dart';
import 'loadingReducer.dart';
import 'userReducer.dart';
import 'yourLocationsReducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appStateReducer(AppState state, action) {
  return AppState(
      yourLocations: yourLocationsReducer(state.yourLocations, action),
      user: userReducer(state.user, action),
      isLoading: loadingReducer(state.isLoading, action),
      isLoaded: loadedReducer(state.isLoaded, action),
      error: errorReducer(state.error, action),
      fireMapState: fireMapReducer(state.fireMapState, action),
    firesApiKey: state.firesApiKey,
    firesApiUrl: state.firesApiUrl,
    gmapKey: state.gmapKey
  );
}
