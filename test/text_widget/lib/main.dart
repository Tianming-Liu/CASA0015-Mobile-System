import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: false),
        home: Scaffold(
          appBar: AppBar(title: Text('Text Widget')),
          body: Center(
              child: Text('This is a text widget',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none))),
        ));
  }
}
