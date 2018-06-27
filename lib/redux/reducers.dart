import '../models/appState.dart';
import 'yourLocationsReducer.dart';
import 'loadedReducer.dart';
import 'loadingReducer.dart';
import 'errorReducer.dart';
import 'userIdReducer.dart';
import 'userTokenReducer.dart';
import 'fireMapReducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appStateReducer(AppState state, action) {

 return   AppState(
      yourLocations: yourLocationsReducer(state.yourLocations, action),
      userId: userReducer(state.userId, action),
      token: userTokenReducer(state.token, action),
      isLoading: loadingReducer(state.isLoading, action),
      isLoaded: loadedReducer(state.isLoaded, action),
      error: errorReducer(state.error, action),
      fireMapState: fireMapReducer(state.fireMapState, action)
 );
}
