import 'package:bson_objectid/bson_objectid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'package:redux/src/store.dart';

import 'models/appState.dart';
import 'redux/actions.dart';

final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

// https://pub.dartlang.org/packages/firebase_messaging#-example-tab-
void firebaseConfig(Store<AppState> store) {
  _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print("onMessage: $message");
    onMessage(message, store);
    //_showItemDialog(message);
  }, onLaunch: (Map<String, dynamic> message) {
    print("onLaunch: $message");
    //_navigateToItemDetail(message);
    onMessage(message, store);
  }, onResume: (Map<String, dynamic> message) {
    print("onResume: $message");
    //_navigateToItemDetail(message);
    onMessage(message, store);
  });

  getToken(store);
}

void onMessage(Map<String, dynamic> message, Store<AppState> store) {
  FireNotification notif = new FireNotification(
      id: new ObjectId.fromHexString(message['id']),
      lat: double.parse(message['lat']),
      lon: double.parse(message['lon']),
      description: message['description'],
      when: DateTime.parse(message['when']));
  print(notif);
  store.dispatch(new AddFireNotificationAction(notif));
}

getToken(Store<AppState> store) async {
  String token = await _firebaseMessaging.onTokenRefresh.first;
  // print(token);
  store.dispatch(new OnUserTokenAction(token));
}
