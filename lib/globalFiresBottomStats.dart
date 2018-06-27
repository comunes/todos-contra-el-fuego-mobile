import 'package:flutter/material.dart';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:comunes_flutter/comunes_flutter.dart';
import 'customBottomAppBar.dart';
import 'colors.dart';
import 'generated/i18n.dart';
import 'customMoment.dart';

class GlobalFiresBottomStats extends StatefulWidget {
  @override
  _GlobalFiresBottomStatsState createState() => _GlobalFiresBottomStatsState();
}

class _GlobalFiresBottomStatsState extends State<GlobalFiresBottomStats> {
  String lastCheck;
  int activeFires = 0;

  @override
  void initState() {
    super.initState();
    http.read('${globals.firesApiUrl}status/last-fire-check').then((result) {
      try {
        var now = Moment.now();
        var last = DateTime.parse(json.decode(result)['value']);
        setState(() {
          lastCheck = now.from(context, last);
        });
      } catch (e) {
        print('Cannot get the last fire check');
      }
    });
    http.read('${globals.firesApiUrl}status/active-fires-count').then((result) {
      try {
        int count = json.decode(result)['total'];
        setState(() {
          activeFires = count;
        });
      } catch (e) {
        print('Cannot get the last fire stats');
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
            new Text(S.of(context).activeFiresWorldWide(activeFires.toString())),
            new Text(S.of(context).updatedLastCheck(lastCheck))
          ])
          : null,
        SizedBox(width: 10.0)
      ]));
  }
}
