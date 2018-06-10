import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar(
      {this.fabLocation,
      this.showNotch,
      this.color = Colors.black45,
      this.actions});

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final bool showNotch;
  final List<Widget> actions;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      new SizedBox(height:56.0)
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: const SizedBox()),
      );
    }

    rowContents.addAll(this.actions);

    return new BottomAppBar(
      color: color,
      hasNotch: showNotch,
      child: new Row(children: rowContents),
    );
  }
}