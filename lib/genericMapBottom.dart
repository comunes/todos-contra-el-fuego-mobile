import 'dart:async';

import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:fires_flutter/models/yourLocation.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'customBottomAppBar.dart';
import 'customMoment.dart';
import 'generated/i18n.dart';
import 'models/appState.dart';
import 'models/fireMapState.dart';

typedef void OnSave();
typedef void OnCancel();
typedef void OnFalsePositive();

class GenericMapBottom extends StatelessWidget {
  final OnSave onSave;
  final OnCancel onCancel;
  final FireMapState state;
  final GlobalKey<ScaffoldState> scaffoldKey;

  GenericMapBottom(
      {@required this.onSave,
      @required this.onCancel,
      @required this.state,
      @required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    YourLocation loc = state.yourLocation;
    int kmAround = loc.distance;
    return new CustomBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerFloat,
        showNotch: false,
        color: fires100,
        mainAxisAlignment: MainAxisAlignment.center,
        actions: buildActionList(loc, context, kmAround, scaffoldKey));
  }

  List<Widget> buildActionList(YourLocation loc, BuildContext context,
      int kmAround, GlobalKey<ScaffoldState> scaffoldState) {
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
      case FireMapStatus.viewFireNotification:
        actionList.add(new Flexible(
            child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: listWithoutNulls(<Widget>[
                      new Text(state.fireNotification.description),
                      // TODO fire type (neighbout, NASA, etc)
                      new SizedBox(height: 5.0),
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.access_time),
                          new SizedBox(width: 5.0),
                          new Text(Moment
                              .now()
                              .from(context, state.fireNotification.when)),
                        ],
                      ),
                      state.industries.length > 0 || state.falsePos.length > 0
                          ? new Padding(
                              padding: new EdgeInsets.only(top: 10.0),
                              child: new Text(
                                  S.of(context).itSeemsNotAtForesFire,
                                  style: new TextStyle(color: fires600)))
                          : null,
                      new DropdownButton<String>(
                          style: new TextStyle(
                            color: Colors.black,
                            // fontSize: 18.0,
                          ),
                          hint: new Text(S.of(context).notAWildfire),
                          items: <String>[
                            S.of(context).itSeemsAIndustry,
                            S.of(context).itSeemsAControlledBurning,
                            S.of(context).itSeemsAFalseAlarm
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                                value: value, child: new Text(value));
                          }).toList(),
                          onChanged: (value) async {
                            // FIXME api call
                            await new Future.delayed(
                                new Duration(milliseconds: 500));
                            scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text(
                                  S.of(context).thanksForParticipating),
                            ));
                          }),
                    ])))));
        break;
      case FireMapStatus.unsubscribe:
      case FireMapStatus.view:
        if (state.numFires != null) {
          actionList.add(new Text(state.numFires > 0
              ? loc.currentNumFires == 1
                  ? S.of(context).fireAroundThisArea(loc.distance.toString())
                  : S.of(context).firesAroundThisArea(
                      state.numFires.toString(), kmAround.toString())
              : S.of(context).noFiresAroundThisArea(kmAround.toString())));
          // SizedBox(width: 10.0)
        }
    }
    return actionList;
  }
}
