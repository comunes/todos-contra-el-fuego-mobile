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

class DeleteYourLocationAction extends YourLocationActions {
  YourLocation loc;

  DeleteYourLocationAction(this.loc);
}

class DeletedYourLocationAction extends YourLocationActions {
  ObjectId id;

  DeletedYourLocationAction(this.id);
}

class UpdateYourLocationAction extends YourLocationActions {
  YourLocation loc;

  UpdateYourLocationAction(this.loc);
}

class UpdatedYourLocationAction extends YourLocationActions {
  YourLocation loc;

  UpdatedYourLocationAction(this.loc);
}

class ToggleSubscriptionAction extends YourLocationActions {
  YourLocation loc;

  ToggleSubscriptionAction(this.loc);
}

class ToggledSubscriptionAction extends YourLocationActions {
  YourLocation loc;

  ToggledSubscriptionAction(this.loc);
}

class SubscribeAction extends YourLocationActions {}

class SubscribeConfirmAction extends YourLocationActions {
  YourLocation loc;

  SubscribeConfirmAction(this.loc);
}

class UnSubscribeAction extends YourLocationActions {
  YourLocation loc;

  UnSubscribeAction(this.loc);
}
