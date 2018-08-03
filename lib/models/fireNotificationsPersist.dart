import 'dart:async';
import 'dart:convert';

import 'package:fires_flutter/models/fireNotification.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import '../globals.dart' as globals;

final String fireNotificationKey = 'fireNotifications';

Future<List<FireNotification>> loadFireNotifications() async {
  return await globals.prefs.then((prefs) {
    List<String> FireNotifications = prefs.getStringList(fireNotificationKey);
    List<FireNotification> persistedList = List<FireNotification>();
    if (FireNotifications == null) {
      FireNotifications = [];
      // first run, init with empty list
      persistFireNotifications(persistedList);
    }
    if (FireNotifications is List) {
      FireNotifications.forEach((notificationString) {
        Map notificationMap = json.decode(notificationString);
        persistedList.add(FireNotification.fromJson(notificationMap));
      });
    }
    return persistedList;
  });
}

persistFireNotifications(List<FireNotification> notif) {
  print('Persisting $notif');
  globals.prefs.then((prefs) {
    List<String> notifAsString = [];
    notif.where(notNull).toList().forEach((notification) {
      notifAsString.add(json.encode(notification.toJson()));
    });
    prefs.setStringList(fireNotificationKey, notifAsString);
  });
}
