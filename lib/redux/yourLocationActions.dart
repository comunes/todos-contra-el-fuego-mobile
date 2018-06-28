import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:meta/meta.dart';

abstract class YourLocationActions {}

class AddYourLocationAction extends YourLocationActions {
  YourLocation loc;

  AddYourLocationAction(this.loc);
}

class AddedYourLocationAction extends YourLocationActions {
  YourLocation loc;

  AddedYourLocationAction(this.loc);
}

class ShowYourLocationMapAction extends YourLocationActions {
  YourLocation loc;

  ShowYourLocationMapAction(this.loc);
}

class UpdateYourLocationMapStatsAction extends YourLocationActions {
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

class DeleteYourLocationAction extends YourLocationActions {
  YourLocation loc;

  DeleteYourLocationAction(this.loc);
}

class DeletedYourLocationAction extends YourLocationActions {
  ObjectId id;

  DeletedYourLocationAction(this.id);
}

class UpdateLocalYourLocationAction extends YourLocationActions {
  YourLocation loc;

  UpdateLocalYourLocationAction(this.loc);
}

class ToggleSubscriptionAction extends YourLocationActions {
  YourLocation loc;

  ToggleSubscriptionAction(this.loc);
}

class ToggledSubscriptionAction extends YourLocationActions {
  YourLocation loc;

  ToggledSubscriptionAction(this.loc);
}

class SubscribeAction extends YourLocationActions {
  SubscribeAction();
}

class SubscribeConfirmAction extends YourLocationActions {
  YourLocation loc;

  SubscribeConfirmAction(this.loc);
}

class UnSubscribeAction extends YourLocationActions {
  YourLocation loc;

  UnSubscribeAction(this.loc);
}

