import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

// https://pub.dartlang.org/packages/firebase_messaging#-example-tab-
void firebaseConfig() {
  _firebaseMessaging.configure(
    onLaunch: (Map<String, dynamic> message) {
      print('On firebase launch');
    },
    onMessage: (Map<String, dynamic> message) {
      print('On firebase message');
    },
    onResume: (Map<String, dynamic> message) {
      print('On firebase resume');
    }
  );
  getToken();
}

getToken() async {
  String token = await _firebaseMessaging.onTokenRefresh.first;
  print(token);
  // await _firebaseMessaging.getToken();
}