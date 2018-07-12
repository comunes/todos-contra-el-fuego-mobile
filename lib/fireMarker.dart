import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'fireMarkerIcon.dart';
import 'fireMarkType.dart';

class FireMarker extends Marker {

  FireMarker(location, type,
      [onTap = null, AnchorPos anchor = AnchorPos.center, Anchor anchorOverride])
      : super(
          width: 80.0,
          height: 80.0,
          point: new LatLng(location.lat, location.lon),
          builder: (ctx) => new Container(
                child: new GestureDetector(
                  child: new FireMarkerIcon(type), onTap: onTap)
              ),
          anchor: anchor,
          anchorOverride: anchorOverride ?? type == FireMarkType.position
              ? new Anchor(40.0, 20.0)
              : type == FireMarkType.fire
                  ? new Anchor(40.0, 24.0)
                  : type == FireMarkType.pixel
                      ? null // auto calculate with height/width in Marker
                      // industries, etc (below)
                      // FIXME check if this is accurate
                      : new Anchor(40.0, 35.0),
        );
}
