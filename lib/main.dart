import 'package:flutter/material.dart';
import 'package:ffl_draw/core/auth/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FFL DRAW',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: Auth()
    );
  }
}