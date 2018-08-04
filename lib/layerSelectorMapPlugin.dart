import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:redux/redux.dart';

import 'models/appState.dart';
import 'redux/actions.dart';

class LayerSelectorMapPluginOptions extends LayerOptions {
  final String text;

  LayerSelectorMapPluginOptions({this.text = ""});
}

// https://github.com/apptreesoftware/flutter_map/blob/master/flutter_map_example/lib/pages/plugin_api.dart
class LayerSelectorMapPlugin extends MapPlugin {
  Widget LayerSelectorButton(Store<AppState> store) {
    return new FloatingActionButton(
      backgroundColor: Colors.black26,
      mini: true,
        child: Icon(Icons.layers, /* size: 40.0, color: Colors.black45, */ ),
        onPressed: () {
          store.dispatch(new ToggleMapLayerAction());
        });
  }

  @override
  Widget createLayer(LayerOptions options, MapState mapState) {
    Store<AppState> store = Injector.getInjector().get<Store<AppState>>();
    if (options is LayerSelectorMapPluginOptions) {
      return LayoutBuilder(
          builder: (context, constraints) =>
              Stack(fit: StackFit.expand, children: <Widget>[
                Positioned(
                  top: constraints.maxHeight - 60,
                  left: 10.0,
                  child: new CenteredRow(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[LayerSelectorButton(store)],
                      )
                    ],
                  ),
                )
              ]));
    }
    throw ("Unknown options type for LayerSelectorMapPlugin"
        "plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LayerSelectorMapPluginOptions;
  }
}
