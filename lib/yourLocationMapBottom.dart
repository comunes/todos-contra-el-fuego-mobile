import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'generated/i18n.dart';
import 'models/appState.dart';
import 'models/fireMapState.dart';
import 'redux/actions.dart';

@immutable
class _ViewModel {
  final FireMapState state;
  final OnLocationEditConfirm onLocationEditConfirm;
  final OnLocationEditCancel onLocationEditCancel;

  _ViewModel(
      {@required this.state,
      @required this.onLocationEditConfirm,
      @required this.onLocationEditCancel});

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
        distinct: true,
        converter: (store) {
          return new _ViewModel(
              state: store.state.fireMapState,
              onLocationEditConfirm: (loc) =>
                  store.dispatch(new EditConfirmYourLocationAction(loc)),
              onLocationEditCancel: (loc) =>
              store.dispatch(new
                EditCancelYourLocationAction(loc)));
        },
        builder: (context, view) {
          YourLocation loc = view.state.yourLocation;
          int kmAround = loc.distance;
          return new CustomBottomAppBar(
              fabLocation: FloatingActionButtonLocation.centerFloat,
              showNotch: false,
              color: fires100,
              // height: 170.0,
              mainAxisAlignment: MainAxisAlignment.center,
              actions: buildActionList(view, loc, context, kmAround));
        });
  }

  List<Widget> buildActionList(
      _ViewModel view, YourLocation loc, BuildContext context, int kmAround) {
    List<Widget> actionList = new List<Widget>();
    switch (view.state.status) {
      case FireMapStatus.edit:
        actionList.add(new FlatButton(
            onPressed: () => view.onLocationEditConfirm(loc),
            child: new Text(S.of(context).SAVE, style: Theme.of(context).textTheme.button)));
        actionList.add(new FlatButton(
            onPressed: () => view.onLocationEditCancel(loc),
            child: new Text(S.of(context).CANCEL, style: Theme.of(context).textTheme.button)));
        break;
      case FireMapStatus.subscriptionConfirm:
        break;
      case FireMapStatus.unsubscribe:
      case FireMapStatus.view:
        if (view.state.numFires != null) {
          actionList.add(new Text(view.state.numFires > 0
              ? S.of(context).firesAroundThisArea(
                  view.state.numFires.toString(), kmAround.toString())
              : S.of(context).noFiresAroundThisArea(kmAround.toString())));
          // SizedBox(width: 10.0)
        }
    }
    return actionList;
  }
}
