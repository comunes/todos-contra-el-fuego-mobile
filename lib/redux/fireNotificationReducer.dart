import 'package:redux/redux.dart';

import 'actions.dart';
import 'package:fires_flutter/models/fireNotification.dart';

final fireNotificationReducer = combineReducers<List<FireNotification>>([
  new TypedReducer<List<FireNotification>, AddedFireNotificationAction>(
      _receivedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedFireNotificationAction>(
    _deletedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedAllFireNotificationAction>(
    _deletedAllFireNotifications)
]);

List<FireNotification> _receivedFireNotification(
    List<FireNotification> yourLocations, AddedFireNotificationAction action) {
  return new List.from(yourLocations)..add(action.notif);
}

List<FireNotification> _deletedFireNotification(
  List<FireNotification> notifications, DeletedFireNotificationAction action) {
  return new List.from(notifications)..remove(action.notif);
}

List<FireNotification> _deletedAllFireNotifications(
  List<FireNotification> notifications, DeletedAllFireNotificationAction action) {
  return new List<FireNotification>();
}
