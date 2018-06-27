import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/src/store.dart';

import 'models/appState.dart';
import 'redux/actions.dart';

final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

// https://pub.dartlang.org/packages/firebase_messaging#-example-tab-
void firebaseConfig(Store<AppState> store) {
  _firebaseMessaging.configure(onLaunch: (Map<String, dynamic> message) {
    print('On firebase launch');
  }, onMessage: (Map<String, dynamic> message) {
    print('On firebase message');
  }, onResume: (Map<String, dynamic> message) {
    print('On firebase resume');
  });
  getToken(store);
}

getToken(Store<AppState> store) async {
  String token = await _firebaseMessaging.onTokenRefresh.first;
  store.dispatch(new OnUserTokenAction(token));
}
