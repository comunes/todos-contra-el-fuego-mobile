import 'package:fires_flutter/models/fireNotification.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

final fireNotificationReducer = combineReducers<List<FireNotification>>([
  new TypedReducer<List<FireNotification>, AddedFireNotificationAction>(
      _addedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedFireNotificationAction>(
      _deletedFireNotification),
  new TypedReducer<List<FireNotification>, UpdatedFireNotificationAction>(
      _updatedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedAllFireNotificationAction>(
      _deletedAllFireNotifications),
  new TypedReducer<List<FireNotification>, ReadedFireNotificationAction>(
      _readedFireNotification)
]);

List<FireNotification> _addedFireNotification(
    List<FireNotification> notifications, AddedFireNotificationAction action) {
  return new List.from(notifications)..insert(0, action.notif);
}

List<FireNotification> _deletedFireNotification(
    List<FireNotification> notifications,
    DeletedFireNotificationAction action) {
  return new List.from(notifications)..remove(action.notif);
}

List<FireNotification> _updatedFireNotification(
    List<FireNotification> notifications, UpdatedFireNotificationAction action) {
  return notifications
      .map((notif) => notif.id == action.notif.id ? action.notif : notif)
      .toList();
}

List<FireNotification> _readedFireNotification(
    List<FireNotification> notifications, ReadedFireNotificationAction action) {
  return notifications
      .map((yourLocation) =>
          yourLocation.id == action.notif.id ? action.notif : yourLocation)
      .toList();
}

List<FireNotification> _deletedAllFireNotifications(
    List<FireNotification> notifications,
    DeletedAllFireNotificationAction action) {
  return new List<FireNotification>();
}
