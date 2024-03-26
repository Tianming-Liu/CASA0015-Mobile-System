import 'package:flutter/material.dart';

class NewGeoTag extends StatefulWidget {
  const NewGeoTag({super.key});

  @override
  State<NewGeoTag> createState() => _NewGeoTagState();
}

class _NewGeoTagState extends State<NewGeoTag> {
  // A built-in class for handling User Input
  // Attention: You need to add dispose methods to delete the Controller from cash!
  final _noteController = TextEditingController();

  // A method called automatically by StatefulWidget, just like the initState and Build
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _noteController,
            maxLength: 30,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                labelText: 'Write some notes for your new record.'),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(_noteController.text);
                  },
                  child: const Text('Save Record'))
            ],
          )
        ],
      ),
    );
  }
}
