import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';

class FiresSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new SpinKitPulse(color: fires600);
  }
}
