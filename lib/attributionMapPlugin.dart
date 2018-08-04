import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/plugin_api.dart';

class AttributionPluginOptions extends LayerOptions {
  final String text;

  AttributionPluginOptions({this.text = ""});
}

class AttributionPlugin implements MapPlugin {
  @override
  Widget createLayer(LayerOptions options, MapState mapState) {
    if (options is AttributionPluginOptions) {
      var style = new TextStyle(
        // fontWeight: FontWeight.bold,
        fontSize: 12.0,
        color: Colors.white,
      );
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Text(
          options.text,
          style: style,
        ),
      );
    }
    throw ("Unknown options type for Attribution"
        "plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AttributionPluginOptions;
  }
}
