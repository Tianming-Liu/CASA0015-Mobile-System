import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/style/custom_text_style.dart';
import 'package:geotracker/models/geotag.dart';

import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/widgets/create_geodata/image_input.dart';

class CreateTagPage extends ConsumerStatefulWidget {
  const CreateTagPage({super.key});

  @override
  ConsumerState<CreateTagPage> createState() => _CreateTagPageState();
}

class _CreateTagPageState extends ConsumerState<CreateTagPage> {
  final _noteController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveData() async {
    final enteredNote = _noteController.text;
    final enteredType = dropDownType.toString().split('.').last;
    final time = DateTime.now();

    if (enteredNote.isEmpty || enteredType.isEmpty || _selectedImage == null) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return; // Check if the widget is still active

      ref
          .read(userRecordProvider.notifier)
          .addPlaceRecord(dropDownType, TagType.place, time, enteredNote, _selectedImage!);

      if (!mounted) return;

      FirebaseFirestore.instance
          .collection('locationData')
          .doc(user.uid)
          .collection('tag')
          .add({
        'category': enteredType,
        'note': enteredNote,
        'time': time,
        'username': userData['username'],
      });
      _noteController.clear();

      Navigator.pop(context);
    } catch (e) {
      // ignore: avoid_print
      print("Error during Firebase operation: $e");
    }
  }

  Category dropDownType = Category.leisure;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '  Category: ',
                      style: CustomTextStyle.normalText,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 200, 200, 200),
                          width: 1,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      padding:
                          const EdgeInsets.only(right: 10), // 调整内边距来对齐文本和图标
                      child: DropdownButton<Category>(
                        isDense: true,
                        isExpanded: true,
                        value: dropDownType,
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                        iconSize: 20,
                        onChanged: (Category? value) {
                          setState(() {
                            dropDownType = value!;
                          });
                        },
                        style: CustomTextStyle.normalText,
                        items: Category.values
                            .map<DropdownMenuItem<Category>>((Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          );
                        }).toList(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        padding: const EdgeInsets.all(10),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 90,
                ),

                //Image Input Widget for the user to select an image
                ImageInput(
                  onSelectedImage: (image) {
                    _selectedImage = image;
                  },
                ),
              ],
            ),
            // const SizedBox(
            //   height: 0,
            // ),
            // Image Input
            TextField(
              controller: _noteController,
              maxLength: 30,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              style: CustomTextStyle.smallBoldBlackText,
              decoration: InputDecoration(
                labelText: 'Write some notes for your new record.',
                labelStyle: CustomTextStyle.smallBoldGreyText,
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
                    onPressed: () {
                      _saveData();
                    },
                    child: const Text('Save Record')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
