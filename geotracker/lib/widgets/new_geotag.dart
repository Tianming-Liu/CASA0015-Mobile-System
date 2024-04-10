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

  ButtonStyle buttonStyleforNewTag = ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(10, 132, 255, 1),
      ), // Background Color
      padding:
          MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)), //
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Round Radius
        ),
      ));

  TextStyle textStyleforNewTag = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  // A method called automatically by StatefulWidget, just like the initState and Build
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Tag Current Location',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Tag Other Location',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Track New Route',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _noteController,
            maxLength: 30,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                labelText: 'Write some notes for your new record.'),
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
