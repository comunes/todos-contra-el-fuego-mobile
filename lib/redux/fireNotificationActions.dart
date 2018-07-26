import 'package:fires_flutter/models/fireNotification.dart';

abstract class FireNotificationActions {}

class DeleteFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  DeleteFireNotificationAction(this.notif);
}

class DeleteAllFireNotificationAction extends FireNotificationActions {
  DeleteAllFireNotificationAction();
}

class AddFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  AddFireNotificationAction(this.notif);
}

class DeletedFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  DeletedFireNotificationAction(this.notif);
}

class DeletedAllFireNotificationAction extends FireNotificationActions {
  DeletedAllFireNotificationAction();
}

class AddedFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  AddedFireNotificationAction(this.notif);
}

class ReadFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  ReadFireNotificationAction(this.notif);
}

class ReadedFireNotificationAction extends FireNotificationActions {
  final FireNotification notif;

  ReadedFireNotificationAction(this.notif);
}
