// Copyright (c) 2016, rinukkusu. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'generated/i18n.dart';
import 'package:flutter/material.dart';

class Moment {
  DateTime _date;

  Moment.now() {
    _date = new DateTime.now();
  }

  Moment.fromDate(DateTime date) {
    _date = date;
  }

  Moment.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
      {bool isUtc: false}) {
    _date = new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
        isUtc: isUtc);
  }

  static Moment parse(String date) {
    return new Moment.fromDate(DateTime.parse(date));
  }

  String toString() {
    return _date.toString();
  }

  String fromNow(BuildContext context, [bool withoutPrefixOrSuffix = false]) {
    return from(context, new DateTime.now(), withoutPrefixOrSuffix);
  }

  String from(BuildContext context, DateTime date, [bool withoutPrefixOrSuffix = false]) {
    Duration diff = date.difference(_date);

    String timeString = "";

    if (diff.inSeconds.abs() < 45) timeString = S.of(context).aF3wSeconds;
    else if (diff.inMinutes.abs() < 2) timeString = S.of(context).aMinute;
    else if (diff.inMinutes.abs() < 45) timeString = S.of(context).inMinutes(diff.inMinutes.abs().toString());
    else if (diff.inHours.abs() < 2) timeString = S.of(context).anHour;
    else if (diff.inHours.abs() < 22) timeString = S.of(context).inHours(diff.inHours.abs().toString());
    else if (diff.inDays.abs() < 2) timeString = S.of(context).aDay;
    else if (diff.inDays.abs() < 26) timeString = S.of(context).inDays(diff.inDays.abs().toString());
    else if (diff.inDays.abs() < 60) timeString = S.of(context).aMonth;
    else if (diff.inDays.abs() < 320) timeString = S.of(context).inMonths((diff.inDays.abs() ~/ 30).toString());
    else if (diff.inDays.abs() < 547) timeString = S.of(context).aYear;
    else timeString = S.of(context).inYears((diff.inDays.abs() ~/ 356).toString());

    if (!withoutPrefixOrSuffix) {
      if (diff.isNegative)
        timeString =S.of(context).somethingAgo(timeString);

      else
        timeString =S.of(context).inSomething(timeString);
    }

    return timeString;
  }
}
