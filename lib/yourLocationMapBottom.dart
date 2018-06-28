import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'generated/i18n.dart';
import 'models/appState.dart';
import 'models/fireMapState.dart';

@immutable
class _ViewModel {
  final FireMapState state;

  _ViewModel({@required this.state});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          state == other.state;

  @override
  int get hashCode => state.hashCode;
}

class YourLocationMapBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        distinct: true, // FIXME
        converter: (store) {
          return new _ViewModel(state: store.state.fireMapState);
        },
        builder: (context, view) {
          int kmAround = view.state.yourLocation.distance;
          return new CustomBottomAppBar(
              fabLocation: FloatingActionButtonLocation.centerFloat,
              showNotch: false,
              color: fires100,
              // height: 170.0,
              mainAxisAlignment: MainAxisAlignment.center,
              actions: listWithoutNulls(<Widget>[
                view.state.status == FireMapStatus.subscriptionConfirm ||
                        view.state.numFires == null
                    ? null
                    : new Text(view.state.numFires > 0
                        ? S.of(context).firesAroundThisArea(
                            view.state.numFires.toString(), kmAround.toString())
                        : S
                            .of(context)
                            .noFiresAroundThisArea(kmAround.toString())),
                SizedBox(width: 10.0)
              ]));
        });
  }
}
