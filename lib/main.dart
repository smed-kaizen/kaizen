import 'package:flutter/material.dart';
import 'package:kaizen/api/Api.dart';
import 'package:kaizen/db/Provider.dart';
import 'package:kaizen/ui/pages/home.dart';
import 'package:kaizen/pages/loading.dart';
import 'package:kaizen/pages/settings.dart';
import 'package:kaizen/pages/stats.dart';
import 'package:sqflite/sqflite.dart';

late Database dbProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.init();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      // '/settings': (context) => Settings(),
      // '/loading': (context) => Loading(),
      // '/stats': (context) => Stats(),
    },
  ));
}
