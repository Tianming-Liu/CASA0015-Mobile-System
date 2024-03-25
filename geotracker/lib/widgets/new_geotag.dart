import 'package:flutter/material.dart';

class NewGeoTag extends StatefulWidget {
  const NewGeoTag({super.key});

  @override
  State<NewGeoTag> createState() => _NewGeoTagState();
}

class _NewGeoTagState extends State<NewGeoTag> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(maxLength: 30, keyboardType: TextInputType.text,decoration: InputDecoration(labelText: 'Write some notes for your new record.'),),
        ],
      ),
    );
  }
}
