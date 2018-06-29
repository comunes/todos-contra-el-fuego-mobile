import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import 'package:redux/redux.dart';

import '../models/appState.dart';
import '../models/firesApi.dart';
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

FiresApi api = Injector.getInjector().get<FiresApi>(FiresApi);

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

  if (action is AddYourLocationAction) {
    if (action.loc.subscribed) {
      subscribeViaApi(store, action.loc,
          (sub) => store.dispatch(new AddedYourLocationAction(sub)));
    } else {
      // No subscribed (only local)
      store.dispatch(new AddedYourLocationAction(action.loc));
      persistYourLocations(store.state.yourLocations);
    }
  }

  if (action is DeleteYourLocationAction) {
    store.dispatch(new DeletedYourLocationAction(action.loc.id));
    if (action.loc.subscribed) {
      unsubsViaApi(store, action.loc.id, () {
        persistYourLocations(store.state.yourLocations);
      });
    } else {
      persistYourLocations(store.state.yourLocations);
    }
  }

  if (action is ShowYourLocationMapAction) {
    api
        .getYourLocationFireStats(store.state, action.loc)
        .then((result) => store.dispatch(result));
  }

  if (action is UpdateLocalYourLocationAction) {
    if (action.loc.subscribed)
      Debounce.seconds(
          2,
          () => api
              .getYourLocationFireStats(store.state, action.loc)
              .then((result) => store.dispatch(result)));
  }

  if (action is SubscribeConfirmAction) {
    subscribeViaApi(store, action.loc, (sub) {
      store.dispatch(new UpdateLocalYourLocationAction(action.loc));
      persistYourLocations(store.state.yourLocations);
    });
  }

  if (action is UnSubscribeAction) {
    unsubsViaApi(store, action.loc.id, () {
      store.dispatch(new UpdateLocalYourLocationAction(action.loc));
      persistYourLocations(store.state.yourLocations);
    });
  }

  if (action is ToggleSubscriptionAction) {
    if (action.loc.subscribed) {
      subscribeViaApi(store, action.loc,
          (sub) => store.dispatch(new ToggledSubscriptionAction(sub)));
    } else {
      unsubsViaApi(store, action.loc.id,
          () => store.dispatch(new ToggledSubscriptionAction(action.loc)));
    }
  }

  if (action is FetchYourLocationsAction) {
    // Use the api to fetch the YourLocations
    api
        .fetchYourLocations(store.state)
        .then((List<YourLocation> subscribedLocations) {
      // If it succeeds, dispatch a success action with the YourLocations.
      // Our reducer will then update the State using these YourLocations.
      // print('Subscribed to: ${subscribedLocations.length}');
      loadYourLocations().then((localLocations) {
        // unsubscribe all locally to sync the subs state
        localLocations.forEach((location) => location.subscribed = false);
        // print('Local persisted: ${localLocations.length}');
        subscribedLocations.forEach((subsLoc) {
          localLocations.firstWhere(
              (localLocation) => localLocation.id == subsLoc.id, orElse: () {
            localLocations.add(subsLoc);
          }).subscribed = true;
        });
        store.dispatch(new FetchYourLocationsSucceededAction(localLocations));
        persistYourLocations(localLocations);
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

void unsubsViaApi(Store<AppState> store, ObjectId id, onUnsubs) {
  api.unsubscribe(store.state, id.toHexString()).then((res) {
    onUnsubs();
    persistYourLocations(store.state.yourLocations);
  });
}

void subscribeViaApi(Store<AppState> store, YourLocation loc, onSubs) {
  api.subscribe(store.state, loc).then((subsId) {
    YourLocation sub = loc;
    if (loc.id != subsId) {
      sub.id = new ObjectId.fromHexString(subsId);
    }
    onSubs(sub);
    persistYourLocations(store.state.yourLocations);
  });
}

void createUser(store, lang, token) {
  assert(token != null, "User lang is null");
  assert(token != null, "User mobile token is null");
  api.createUser(store.state, token, lang).then((userId) {
    store.dispatch(new OnUserCreatedAction(userId));
    store.dispatch(new FetchYourLocationsAction());
  });
}
