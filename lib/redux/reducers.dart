import '../models/appState.dart';
import 'appReducer.dart';
import 'errorReducer.dart';
import 'fireMapReducer.dart';
import 'fireNotificationReducer.dart';
import 'loadedReducer.dart';
import 'loadingReducer.dart';
import 'userReducer.dart';
import 'yourLocationsReducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appStateReducer(AppState prevState, action) {
  var state = appReducer(prevState, action);
  return AppState(
      yourLocations: yourLocationsReducer(state.yourLocations, action),
      fireNotifications:
          fireNotificationReducer(state.fireNotifications, action),
      fireNotificationsUnread: state.fireNotificationsUnread,
      user: userReducer(state.user, action),
      isLoading: loadingReducer(state.isLoading, action),
      isLoaded: loadedReducer(state.isLoaded, action),
      error: errorReducer(state.error, action),
      fireMapState: fireMapReducer(state.fireMapState, action),
      firesApiKey: state.firesApiKey,
      firesApiUrl: state.firesApiUrl,
      serverUrl: state.serverUrl,
      gmapKey: state.gmapKey);
}
