import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        title: "My Material App",
        home: Scaffold(
            appBar: AppBar(title: Text("Centering my text")),
            body: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You are at my center!'),
                  Text('More centered text!')
                ])
            )
        )
    );
  }
}
