import 'package:redux/redux.dart';

import '../globals.dart' as globals;
import '../models/appState.dart';
import '../models/firesApi.dart';

import 'package:fires_flutter/models/yourLocation.dart';

import '../models/yourLocationPersist.dart';
import 'actions.dart';

// A middleware takes in 3 parameters: your Store, which you can use to
// read state or dispatch new actions, the action that was dispatched,
// and a `next` function. The first two you know about, and the `next`
// function is responsible for sending the action to your Reducer, or
// the next Middleware if you provide more than one.
//
// Middleware do not return any values themselves. They simply forward
// actions on to the Reducer or swallow actions in some special cases.

FiresApi api = globals.getIt.get<FiresApi>();

void fetchYourLocationsMiddleware(
    Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchYourLocationAction`

  if (action is OnUserLangAction) {
    // I can create the user with the lang and the token
    if (store.state.user.token != null)
      createUser(store, action.lang, store.state.user.token);
  }

  if (action is OnUserTokenAction) {
    // I can create the user with the lang and the token
    if (store.state.user.lang != null)
      createUser(store, store.state.user.lang, action.token);
  }

  if (action is FetchYourLocationsAction) {
    final api = globals.getIt.get<FiresApi>();

    // Use the api to fetch the YourLocations
    api.fetchYourLocations(store.state).then((List<YourLocation> yourSubs) {
      // If it succeeds, dispatch a success action with the YourLocations.
      // Our reducer will then update the State using these YourLocations.

      loadYourLocations().then((localLocations) {
        // unsubscribe all locally to sync the subs state
        localLocations.forEach((location) => location.subscribed = false);

        yourSubs.forEach((loc) {
          localLocations.firstWhere(
              (localLocation) => localLocation.id == loc.id, orElse: () {
            localLocations.add(loc);
          }).subscribed = true;
        });

        persistYourLocations(localLocations);

        store.dispatch(new FetchYourLocationsSucceededAction(localLocations));
      });
    }).catchError((Exception error) {
      // If it fails, dispatch a failure action. The reducer will
      // update the state with the error.
      store.dispatch(new FetchYourLocationsFailedAction(error));
    });
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}

void createUser(store, lang, token) {
  assert(token != null, "User lang is null");
  assert(token != null, "User mobile token is null");
  api.createUser(store.state, token, lang).then((userId) {
    store.dispatch(new OnUserCreatedAction(userId));
    store.dispatch(new FetchYourLocationsAction());
  });
}
