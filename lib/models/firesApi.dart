import 'dart:async';
import 'dart:convert';

import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'appState.dart';

class FiresApi {
  FiresApi() {
    resty.globalClient = new ht.IOClient();
  }

  Future<String> createUser(
      AppState state, String mobileToken, String lang) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    assert(mobileToken != null);
    assert(lang != null);

    final params = {
      "token": state.firesApiKey,
      "mobileToken": mobileToken,
      "lang": lang
    };
    final String url = '${state.firesApiUrl}mobile/users';
    /* print(url);
    print(params); */
    return await resty.post(url).json(params).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body)['data']['userId'];
      }
    });
  }

  Future<List<YourLocation>> fetchYourLocations(AppState state) async {
    final apiKey = state.firesApiKey;
    final mobileToken = state.user.token;
    final String url = '${state
      .firesApiUrl}mobile/subscriptions/all/$apiKey/$mobileToken';
    return await resty.get(url).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        final dataSubscriptions =
            json.decode(response.body)['data']['subscriptions'];
        List<YourLocation> subscribed = [];
        for (int i = 0; i < dataSubscriptions.length; i++) {
          var el = dataSubscriptions[i];
          var lat = el['location']['lat'];
          var lon = el['location']['lon'];
          var id = el['_id']['_str'];
          subscribed.add(new YourLocation(
              id: ObjectId.fromHexString(el['_id']['_str']),
              lat: lat,
              lon: lon,
              subscribed: true,
              distance: el['distance']));
        }

        return subscribed;
      }
    });
  }

  Future<String> subscribe(AppState state, YourLocation loc) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    assert(state.user.token != null);
    assert(loc != null);
    assert(loc.lat != null);
    assert(loc.lon != null);
    assert(loc.id != null);
    assert(loc.distance != null);
    final params = {
      "token": state.firesApiKey,
      "mobileToken": state.user.token,
      "id": loc.id.toHexString(),
      "lat": loc.lat,
      "lon": loc.lon,
      "distance": loc.distance
    };
    final String url = '${state
      .firesApiUrl}mobile/subscriptions';
    return await resty.post(url).json(params).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body)['data']['subsId'];
      } else {
        // take care of? "Unexpected error in REST call: Error: The user is already subscribed to this area [on-already-subscribed]"
        print(response.body);
      }
    });
  }

  Future<bool> unsubscribe(AppState state, String subsId) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    assert(state.user.token != null);
    final apiKey = state.firesApiKey;
    final mobileToken = state.user.token;
    assert(subsId != null);
    final String url = '${state
      .firesApiUrl}mobile/subscriptions/$apiKey/$mobileToken/$subsId';
    return await resty.delete(url).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        return true;
      }
    });
  }
}
