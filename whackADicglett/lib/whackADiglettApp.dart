import 'package:flutter/material.dart';
import 'package:whackadicglett/paginaPrincipal.dart';

class WhackADiglettApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whack a Diglett',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: paginaPrincipal(),
    );
  }
}