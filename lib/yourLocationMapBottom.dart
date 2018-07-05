import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'generated/i18n.dart';
import 'models/appState.dart';
import 'models/fireMapState.dart';

typedef void OnSave();
typedef void OnCancel();

class YourLocationMapBottom extends StatelessWidget {
  final OnSave onSave;
  final OnCancel onCancel;
  final FireMapState state;

  YourLocationMapBottom({@required this.onSave,@required this.onCancel,@required this.state});

  @override
  Widget build(BuildContext context) {
    YourLocation loc = state.yourLocation;
    int kmAround = loc.distance;
    return new CustomBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerFloat,
        showNotch: false,
        color: fires100,
        // height: 170.0,
        mainAxisAlignment: MainAxisAlignment.center,
        actions: buildActionList(loc, context, kmAround));
  }

  List<Widget> buildActionList(
      YourLocation loc, BuildContext context, int kmAround) {
    List<Widget> actionList = new List<Widget>();
    switch (state.status) {
      case FireMapStatus.edit:
        actionList.add(new FlatButton(
            onPressed: onSave,
            child: new Text(S.of(context).SAVE,
                style: Theme.of(context).textTheme.button)));
        actionList.add(new FlatButton(
            onPressed: onCancel,
            child: new Text(S.of(context).CANCEL,
                style: Theme.of(context).textTheme.button)));
        break;
      case FireMapStatus.subscriptionConfirm:
        break;
      case FireMapStatus.unsubscribe:
      case FireMapStatus.view:
        if (state.numFires != null) {
          actionList.add(new Text(state.numFires > 0
              ? S.of(context).firesAroundThisArea(
                  state.numFires.toString(), kmAround.toString())
              : S.of(context).noFiresAroundThisArea(kmAround.toString())));
          // SizedBox(width: 10.0)
        }
    }
    return actionList;
  }
}
