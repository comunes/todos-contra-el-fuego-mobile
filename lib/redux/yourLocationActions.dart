import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';


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

class DeleteYourLocationAction extends YourLocationActions {
  ObjectId id;

  DeleteYourLocationAction(this.id);
}

class DeletedYourLocationAction extends YourLocationActions {
  ObjectId id;

  DeletedYourLocationAction(this.id);
}


class UpdateYourLocationAction extends YourLocationActions {
  ObjectId id;
  YourLocation loc;

  UpdateYourLocationAction(this.id, this.loc);
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
  ObjectId id;

  SubscribeAction(this.id);
}

class UnSubscribeAction extends YourLocationActions {
  ObjectId id;

  UnSubscribeAction(this.id);
}
