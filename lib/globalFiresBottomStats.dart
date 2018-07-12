import 'dart:convert';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:http/http.dart' as http;

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'customMoment.dart';
import 'generated/i18n.dart';

class GlobalFiresBottomStats extends StatefulWidget {
  @override
  _GlobalFiresBottomStatsState createState() => _GlobalFiresBottomStatsState();
}

class _GlobalFiresBottomStatsState extends State<GlobalFiresBottomStats> {
  String lastCheck;
  int activeFires = 0;
  final firesApiUrl = Injector.getInjector().get<String>(key: "firesApiUrl");

  @override
  void initState() {
    super.initState();
    http.read('${firesApiUrl}status/last-fire-check').then((result) {
      try {
        var now = Moment.now();
        var last = DateTime.parse(json.decode(result)['value']);
        http.read('${firesApiUrl}status/active-fires-count').then((result) {
          try {
            int count = json.decode(result)['total'];
            setState(() {
              lastCheck = now.from(context, last);
              activeFires = count;
            });
          } catch (e) {
            print('Cannot get the last fire stats');
            print(e);
          }
        });
      } catch (e) {
        print('Cannot get the last fire check');
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new CustomBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerDocked,
        showNotch: true,
        color: fires100,
        mainAxisAlignment: MainAxisAlignment.center,
        actions: listWithoutNulls(<Widget>[
          activeFires > 0 && lastCheck != null
              ? new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      new Text(S
                          .of(context)
                          .activeFiresWorldWide(activeFires.toString())),
                      new Text(S.of(context).updatedLastCheck(lastCheck))
                    ])
              : null,
          SizedBox(width: 10.0)
        ]));
  }
}
