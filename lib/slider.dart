import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:comunes_flutter/comunes_flutter.dart';

class FireDistanceSlider extends StatefulWidget {
  @override
  _FireDistanceSliderState createState() => new _FireDistanceSliderState();
}

class _FireDistanceSliderState extends State<FireDistanceSlider> {
  int _discreteValue = 10;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Column(
          mainAxisSize: MainAxisSize.min,
          children:
            listWithoutNulls(<Widget>[
            new Slider(
              value: _discreteValue + 0.0,
              activeColor: fires900,
              min: 1.0,
              max: 100.0,
              divisions: 99,
              label: '${_discreteValue.round()}',
              onChanged: (double value) {
                setState(() {
                  _discreteValue = value.round();
                });
              },
            ),
            new Text('Subscribe to $_discreteValue км around this area'),
            _discreteValue >= 50 ?
              new Text(
                'Warning: this is a very large area',
                style: new TextStyle(color: Colors.orange)
              ): new Text('')
          ]),
        ),
      ],
    );
  }
}
