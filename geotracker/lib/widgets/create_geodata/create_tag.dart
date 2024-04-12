import 'package:flutter/material.dart';
import 'package:geotracker/style/custom_text_style.dart';

class CreateTagPage extends StatefulWidget {
  const CreateTagPage({super.key});

  @override
  State<CreateTagPage> createState() => _CreateTagPageState();
}

class _CreateTagPageState extends State<CreateTagPage> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveData() {
    final enteredNote = _noteController.text;
    if (enteredNote.isEmpty) {
      return;
    }

    //send datat to firebase

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _noteController,
            maxLength: 30,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Write some notes for your new record.',
              labelStyle: CustomTextStyle.normalText,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () => _saveData(),
                  child: const Text('Save Record')),
            ],
          ),
        ],
      ),
    );
  }
}
