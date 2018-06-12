import 'package:flutter/material.dart';
import 'fireMarkType.dart';
import 'colors.dart';

class FireMarkerIcon extends StatelessWidget {

  final FireMarkType type;

  FireMarkerIcon(this.type);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FireMarkType.position:
        return new Icon(Icons.location_on, color: fires600, size: 50.0);
      case FireMarkType.pixel:
        return new Icon(Icons.brightness_1, color: fires900, size: 3.0);
      case FireMarkType.fire:
        return new Image.asset('images/fire-marker-l.png');
      case FireMarkType.industry:
        return new Image.asset('images/industry-marker-reg.png');
      case FireMarkType.falsePos:
      default:
        return new Image.asset('images/industry-marker.png');
    }
  }
}
