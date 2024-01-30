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
      home: MyHomePage('Flutter Demo Home screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage(this.title);

  @override
  MyHomePageState createState() { return MyHomePageState();}
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('You have pushed the button this many times:'), Text('$_counter')],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: incrementCounter, child: Icon(Icons.add) )
    );
  }
}
