import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(key:ObjectKey('MyApp')));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3:false),
        home: Scaffold(
            appBar: AppBar(title: Text('Nicer ListView Example')),
            body: MainListView(),
        )
    );
  }
}

class MainListView extends StatelessWidget {

  final List<Widget> months = [Text('January'),Text('February'),Text('March'),Text('April'),Text('May'),Text('June'), Text('July'), Text('August'), Text('September'), Text('October'), Text('November'), Text('December'),];

  @override  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: months[index],
        );
      },
    );
  }

}
