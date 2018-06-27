import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'appState.dart';
import 'yourLocation.dart';

class FiresApi {
  FiresApi() {
    resty.globalClient = new ht.IOClient();
  }

  Future<String> createUser(AppState state, String mobileToken, String lang) async {
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
    String resp = await resty.post(url).json(params).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body)['data']['userId'];
      }
    });
    return resp;
  }

  Future<List<YourLocation>> fetchYourLocations(AppState state) async {
    final apiKey = state.firesApiKey;
    final mobileToken = state.user.token;
    final String url = '${state.firesApiUrl}mobile/subscriptions/all/$apiKey/$mobileToken';
    List<YourLocation> resp = await resty.get(url).go().then((response) {
      if (response.statusCode == 200) {
        // print(response.body);
        print(json.decode(response.body)['data']['subscriptions']);        return [];
      }
    });
    return resp;
  }
}
