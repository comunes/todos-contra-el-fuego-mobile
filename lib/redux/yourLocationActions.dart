import 'package:bson_objectid/bson_objectid.dart';
import 'package:fires_flutter/models/yourLocation.dart';



abstract class YourLocationActions {}

class AddYourLocationAction extends YourLocationActions {
  YourLocation loc;

  AddYourLocationAction(this.loc);
}

class DeleteYourLocationAction extends YourLocationActions {
  ObjectId id;

  DeleteYourLocationAction(this.id);
}

class UpdateYourLocationAction extends YourLocationActions {
  ObjectId id;
  YourLocation loc;

  UpdateYourLocationAction(this.id, this.loc);
}

class ToggleSubscriptionAction extends YourLocationActions {
  ObjectId id;

  ToggleSubscriptionAction(this.id);
}

class SubscribeAction extends YourLocationActions {
  ObjectId id;

  SubscribeAction(this.id);
}

class UnSubscribeAction extends YourLocationActions {
  ObjectId id;

  UnSubscribeAction(this.id);
}
