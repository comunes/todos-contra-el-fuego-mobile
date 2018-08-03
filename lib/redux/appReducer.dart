import 'actions.dart';
import '../models/appState.dart';

AppState appReducer(AppState state, action) {
  if (action is FetchYourLocationsSucceededAction) {
    return state.copyWith(yourLocations: action.fetchedYourLocations);
  }
  if (action is FetchFireNotificationsSucceededAction) {
    return state.copyWith(fireNotifications: action.fetchedFireNotifications,
      fireNotificationsUnread: action.unreadCount);
  }
  if (action is AddedFireNotificationAction)
    return state.copyWith(
      fireNotificationsUnread: state.fireNotificationsUnread + 1);

  if (action is ReadedFireNotificationAction)
    return state.copyWith(
      fireNotificationsUnread: state.fireNotificationsUnread - 1);

  if (action is DeleteAllFireNotificationAction)
    return state.copyWith(
      fireNotificationsUnread: 0);

  return state;
}
