import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Centering text")),
        body: Center(child: Text("Hello, world")),
      )
    );
  }
}