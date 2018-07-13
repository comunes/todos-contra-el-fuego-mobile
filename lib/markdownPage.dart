import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'globals.dart' as globals;

abstract class MarkdownPage extends StatefulWidget {
  final String title;
  final Future<String> file;

  MarkdownPage({this.title, this.file});

  @override
  _MarkdownPageState createState() =>
      _MarkdownPageState(title: this.title, file: this.file);
}

class _MarkdownPageState extends State<MarkdownPage> {
  final String title;
  final Future<String> file;
  String pageData = "";

  _MarkdownPageState({this.title, this.file});

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
        body: new Markdown(data: pageData));
  }
}
