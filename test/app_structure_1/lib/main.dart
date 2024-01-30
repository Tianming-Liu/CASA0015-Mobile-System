import 'package:flutter/material.dart';

void main() {
  //Entry point
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My Material App",
        theme: ThemeData(useMaterial3: false),
        home: Scaffold(
            appBar: AppBar(title: Text("My First Image")),
            body: Center(child: Image(image: AssetImage("images/me.jpg")))
        )
    );
  }
}