import 'package:fires_flutter/models/yourLocation.dart';
import 'package:meta/meta.dart';

abstract class FiresMapActions {}

class UpdateYourLocationMapAction extends FiresMapActions {
  final YourLocation loc;

  UpdateYourLocationMapAction(
    this.loc,
  );
}

class UpdateYourLocationMapStatsAction extends FiresMapActions {
  int numFires;
  List<dynamic> fires = [];
  List<dynamic> falsePos = [];
  List<dynamic> industries = [];

  UpdateYourLocationMapStatsAction(
      {@required this.numFires,
      @required this.fires,
      @required this.falsePos,
      @required this.industries});
}

class ShowYourLocationMapAction extends FiresMapActions {
  YourLocation loc;

  ShowYourLocationMapAction(this.loc);
}
