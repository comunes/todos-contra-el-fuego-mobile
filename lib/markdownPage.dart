import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'globals.dart' as globals;
import 'mainDrawer.dart';

abstract class MarkdownPage extends StatefulWidget {
  final String title;
  final Future<String> file;
  final String route;

  MarkdownPage({this.title, this.route, this.file});

  @override
  _MarkdownPageState createState() =>
      _MarkdownPageState(title: this.title, file: this.file, route: this.route);
}

class _MarkdownPageState extends State<MarkdownPage> {
  final String title;
  final String route;
  final Future<String> file;
  String pageData = "";

  _MarkdownPageState({this.title, this.file, this.route});

  @override
  Widget build(BuildContext context) {
    this.file.then((fileSync) {
      rootBundle
          .loadString(fileSync, cache: !globals.isDevelopment)
          .then((pageData) {
        setState(() {
          this.pageData = pageData;
        });
      });
    });
    return new Scaffold(
        appBar: new AppBar(title: new Text(title ?? '')),
        drawer: new MainDrawer(context, route),
        body: new Markdown(data: pageData));
  }
}
