import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Add area'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      // https://flutter.io/widgets/scrolling/
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FloatingActionButton(
          onPressed: () {
            //
          },
          heroTag: 'image0',
          tooltip: 'Pick Image from gallery',
          child: const Icon(Icons.photo_library),
        ),
      ]),

      body: new SingleChildScrollView(
          child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                new TextFormField(
                    decoration: new InputDecoration(
                        border: const OutlineInputBorder(),
                        helperText: "Write a place to center the map",
                        hintText: 'Write here a place',
                        labelText: 'Your location')),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      )),
    );
  }
}
