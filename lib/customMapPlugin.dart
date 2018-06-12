import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter/material.dart';
import 'package:comunes_flutter/comunes_flutter.dart';

class ZoomMapPluginOptions extends LayerOptions {
  final String text;

  ZoomMapPluginOptions({this.text = ""});
}

// https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/plugin_api.dart
class ZoomMapPlugin extends MapPlugin {
  IconButton zoomButton(MapState mapState, IconData zoomIcon, int inc) {
    return new IconButton(
        icon: Icon(zoomIcon),
        onPressed: () {
          var currentZoom = mapState.zoom;
          var currentCenter = mapState.center;
          mapState.move(currentCenter, currentZoom + inc);
        });
  }

  @override
  Widget createLayer(LayerOptions options, MapState mapState) {
    if (options is ZoomMapPluginOptions) {
      /* print('point ${mapState
        .getPixelBounds(mapState.zoom)
        .bottomLeft}'); */
      return LayoutBuilder(
          builder: (context, constraints) =>
              Stack(fit: StackFit.expand, children: <Widget>[
                Positioned(
                  top: constraints.maxHeight - 100,
                  right: 10.0,
                  // left: 10.0,
                  child: new CenteredRow(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          zoomButton(mapState, Icons.zoom_in, 1),
                          zoomButton(mapState, Icons.zoom_out, -1)
                        ],
                      )
                    ],
                  ),
                )
              ]));
    }
    throw ("Unknown options type for ZoomMapPlugin"
        "plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ZoomMapPluginOptions;
  }
}
