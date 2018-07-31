import 'package:bson_objectid/bson_objectid.dart';

objectIdFromJson(String json) {
  return new ObjectId.fromHexString(json);
}

objectIdToJson(ObjectId o) {
  return o.toString();
}