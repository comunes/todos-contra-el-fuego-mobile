import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:comunes_flutter/comunes_flutter.dart';
import 'package:padder/padding.dart';

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

  sizeText(_sliderValue) =>
      new Text('Subscribe to $_sliderValue км around this area');

  warningText(_sliderValue) => _sliderValue >= 50
      ? new Text('Warning: this is a very large area',
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
        slider,
        new Card(
            color: const Color(0x60FFFFFF),
            child: PaddingAll(10.0,
                child: new Column(children: <Widget>[
                  sizeText(_sliderValue),
                  warningText(_sliderValue)
                ])))
      ]),
    );
  }
}
