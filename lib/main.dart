import 'package:flutter/material.dart';
import 'package:kaizen/pages/home.dart';
import 'package:kaizen/pages/loading.dart';
import 'package:kaizen/pages/settings.dart';
import 'package:kaizen/pages/stats.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/settings': (context) => Settings(),
      '/loading': (context) => Loading(),
      '/stats': (context) => Stats(),
    },
  ));
}
