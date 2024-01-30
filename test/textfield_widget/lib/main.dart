import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: Scaffold(
            appBar: AppBar(title: Text('Flutter TextField Demo')),
            body: MyTextFieldWidget()));
  }
}

class MyTextFieldWidget extends StatefulWidget {
  @override
  State<MyTextFieldWidget> createState() => MyTextFieldWidgetState();
}

class MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  late String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueAccent,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)
              )
            ),
            onSubmitted: (String value) {
              setState(() {
                text = value;
                print(text);
              });
            }));
  }
}
