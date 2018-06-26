import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'generated/i18n.dart';

typedef void SlideCallback(int distance);

class FireDistanceSlider extends StatefulWidget {
  final int initialValue;
  final SlideCallback onSlide;

  FireDistanceSlider({this.initialValue, this.onSlide});

  @override
  _FireDistanceSliderState createState() => new _FireDistanceSliderState(
      initialValue: initialValue, onSlide: onSlide);
}

class _FireDistanceSliderState extends State<FireDistanceSlider> {
  int _sliderValue;
  final SlideCallback onSlide;

  _FireDistanceSliderState({int initialValue = 10, this.onSlide}) {
    this._sliderValue = initialValue;
  }

  sizeText(sliderValue) =>
      new Text(S.of(context).subscribeToValueAroundThisArea(sliderValue.toString()),
          style: new TextStyle(color: Colors.black87));

  warningText(sliderValue) => _sliderValue >= 50
      ? new Text(S.of(context).warningThisIsAVeryLargeArea,
          style: new TextStyle(color: fires900))
      : new Text('');

  @override
  Widget build(BuildContext context) {
    var slider = new Slider(
      value: _sliderValue + 0.0,
      activeColor: fires900,
      inactiveColor: Colors.black45,
      min: 1.0,
      max: 100.0,
      divisions: 99,
      label: '${_sliderValue.round()}',
      onChanged: (double value) {
        _sliderValue = value.round();
        if (onSlide != null) {
          onSlide(_sliderValue);
        }
        setState(() {});
      },
    );
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: listWithoutNulls(<Widget>[
        new SizedBox(height: 50.0),
        new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[slider]),
        // new SizedBox(height: 5.0),
        new Column(children: <Widget>[
          sizeText(_sliderValue),
          new SizedBox(height: 5.0),
          warningText(_sliderValue)
        ])
      ]),
    );
  }
}
