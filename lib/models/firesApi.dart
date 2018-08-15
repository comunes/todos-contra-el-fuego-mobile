import 'dart:async';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'falsePositiveTypes.dart';

import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:latlong/latlong.dart';

import '../globals.dart' as globals;
import '../redux/actions.dart';
import 'appState.dart';

class FiresApi {
  FiresApi() {
    resty.globalClient = new ht.IOClient();
  }

  Future<String> createUser(AppState state, String mobileToken,
    String lang) async {
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
    // if (globals.isDevelopment) print('$url');
    return await resty.get(url).go().then((response) {
      if (response.statusCode == 200) {
        // if (globals.isDevelopment) print(response.body);
        final dataSubscriptions =
        json.decode(response.body)['data']['subscriptions'];
        List<YourLocation> subscribed = [];
        for (int i = 0; i < dataSubscriptions.length; i++) {
          var el = dataSubscriptions[i];
          var lat = el['location']['lat'];
          var lon = el['location']['lon'];
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

  Future<UpdateFireMapStatsAction> getFiresInLocation(
    {AppState state, double lat, double lon, int distance}) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    var url = '${state.firesApiUrl}fires-in-full/${state
      .firesApiKey}/${lat}/${lon}/${distance}';
    if (globals.isDevelopment) print(url);
    return await resty.get(url).go().then((response) {
      if (response.statusCode == 200) {
        var resultDecoded = json.decode(response.body);
        int numFires = resultDecoded['real'];
        List fires = resultDecoded['fires'];
        List falsePos = resultDecoded['falsePos'];
        List industries = resultDecoded['industries'];

        if (globals.isDevelopment) {
          var firesCount = fires.length;
          var industriesCount = industries.length;
          var falsePosCount = falsePos.length;
          print(
            '(Pos: $lat, $lon) real: $numFires, fire: $firesCount falsePos: $falsePosCount industries: $industriesCount');
        }
        return new UpdateFireMapStatsAction(
          numFires: numFires,
          fires: fires,
          falsePos: falsePos,
          industries: industries);
      } else
        throw Exception('Wrong response trying to get fire data');
    });
  }

  Future<List<Polyline>> getMonitoredAreas({AppState state}) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    var url = '${state.firesApiUrl}status/subs-public-union/${state
      .firesApiKey}';
    var color = const Color(0xFF145A32);
    return await resty.get(url).go().then((response) {
      if (response.statusCode == 200) {
        var resultDecoded = json.decode(response.body);
        // print(resultDecoded['data']['union']);
        List<Polyline> union = [];
        final multipolygon =
        json.decode(resultDecoded['data']['union']['value'])['geometry']
        ['coordinates'];
        for (List<dynamic> polygon in multipolygon) {
          for (List<dynamic> hole in polygon) {
            List<LatLng> points = [];
            for (List<dynamic> point in hole) {
              points.add(new LatLng(point[1].toDouble(), point[0].toDouble()));
            }
            union.add(
              new Polyline(points: points, color: color, strokeWidth: 3.0));
          }
        }
        return union;
      } else
        throw Exception('Wrong response trying to get fire data');
    });
  }

  Future<bool> markFalsePositive(AppState state, String mobileToken,
    String sealed, FalsePositiveType type) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    assert(mobileToken != null);
    assert(sealed != null);
    assert(type != null);

    final params = {
      "token": state.firesApiKey,
      "mobileToken": mobileToken,
      "sealed": sealed,
      "type": type.toString().split('.')[1]
    };
    final String url = '${state.firesApiUrl}mobile/falsepositive';
    return await resty.post(url).json(params).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        if (globals.isDevelopment) print(
          json.decode(response.body)['data']['upsert']);
        return true;
      } else {
        debugPrint(json.decode(response.body));
        return false;
      }
    });
  }
}
