import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter/material.dart';

class DummyMapPluginOptions extends LayerOptions {
  final String text;

  DummyMapPluginOptions({this.text = ""});
}

// https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/plugin_api.dart
class DummyMapPlugin extends MapPlugin {

  @override
  Widget createLayer(LayerOptions options, MapState mapState) {
    if (options is DummyMapPluginOptions) {
      return const SizedBox();
    }
    throw ("Unknown options type for DummyMapPlugin"
        "plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is DummyMapPluginOptions;
  }
}
