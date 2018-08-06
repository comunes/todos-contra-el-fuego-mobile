import 'package:fires_flutter/models/yourLocation.dart';
import 'package:fires_flutter/models/fireNotification.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class AppActions {}

class FetchYourLocationsAction extends AppActions {
  Completer<Null> refreshCallback;

  FetchYourLocationsAction([this.refreshCallback]);
}

class PersistAppStateAction extends AppActions {}

class FetchYourLocationsSucceededAction extends AppActions {
  final List<YourLocation> fetchedYourLocations;

  FetchYourLocationsSucceededAction(this.fetchedYourLocations);
}

class FetchFireNotificationsAction extends AppActions {}

class FetchMonitoredAreasAction extends AppActions {}

class FetchYourLocationsFailedAction extends AppActions {
  final Exception error;

  FetchYourLocationsFailedAction(this.error);
}

class OnUserTokenAction extends AppActions {
  final String token;

  OnUserTokenAction(this.token);
}

class OnUserCreatedAction extends AppActions {
  final String userId;

  OnUserCreatedAction(this.userId);
}

class OnUserLangAction extends AppActions {
  final String lang;

  OnUserLangAction(this.lang);
}

class FetchFireNotificationsSucceededAction extends AppActions {
  final List<FireNotification> fetchedFireNotifications;
  final int unreadCount;

  FetchFireNotificationsSucceededAction(this.fetchedFireNotifications, this.unreadCount);
}

class OnConnectivityChanged extends AppActions {
  final ConnectivityResult connectivityResult;

  OnConnectivityChanged(this.connectivityResult);
}

class FetchMonitoredAreasSucceededAction extends AppActions {
  final List<Polyline> monitoredAreas;

  FetchMonitoredAreasSucceededAction(this.monitoredAreas);
}
