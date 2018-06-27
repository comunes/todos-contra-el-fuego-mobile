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

  Future<String> createUser(AppState state, String token, String lang) async {
    assert(state.firesApiUrl != null);
    assert(state.firesApiKey != null);
    assert(token != null);
    assert(lang != null);

    final params = {
      "token": state.firesApiKey,
      "mobileToken": token,
      "lang": lang
    };
    final url = '${state.firesApiUrl}mobile/users';
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

  Future<List<YourLocation>> fetchYourLocations() async {}
}
