import 'package:redux/redux.dart';

import 'actions.dart';
import 'package:fires_flutter/models/fireNotification.dart';

final fireNotificationReducer = combineReducers<List<FireNotification>>([
  new TypedReducer<List<FireNotification>, AddedFireNotificationAction>(
      _receivedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedFireNotificationAction>(
    _deletedFireNotification),
  new TypedReducer<List<FireNotification>, DeletedAllFireNotificationAction>(
    _deletedAllFireNotifications),
  new TypedReducer<List<FireNotification>, ReadedFireNotificationAction>(
    _readedFireNotification)
]);

List<FireNotification> _receivedFireNotification(
    List<FireNotification> notifications, AddedFireNotificationAction action) {
  return new List.from(notifications)..add(action.notif);
}

List<FireNotification> _deletedFireNotification(
  List<FireNotification> notifications, DeletedFireNotificationAction action) {
  return new List.from(notifications)..remove(action.notif);
}

List<FireNotification> _readedFireNotification(
    List<FireNotification> notifications, ReadedFireNotificationAction action) {
  return notifications
      .map((yourLocation) =>
          yourLocation.id == action.notif.id ? action.notif : yourLocation)
      .toList();
}

List<FireNotification> _deletedAllFireNotifications(
  List<FireNotification> notifications, DeletedAllFireNotificationAction action) {
  return new List<FireNotification>();
}
