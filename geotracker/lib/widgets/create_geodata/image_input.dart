import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:geotracker/style/custom_text_style.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _pickedImageFile;

  final ImagePicker _picker = ImagePicker();

  // Method for picking an image from camera
  void _pickImageFromCamera() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  // Method for picking an image from gallery
  void _pickImageFromGallery() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  // For users to choose the source of the image
  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              //Album
              ListTile(
                leading: const Icon(Icons.photo_album,size: 20,color: Color.fromARGB(255, 78, 78, 78),),
                title: Text("Choose from Album",style:CustomTextStyle.smallBoldBlackText,),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              //Camera
              ListTile(
                leading: const Icon(Icons.camera_alt,size: 20,color: Color.fromARGB(255, 78, 78, 78),),
                title: Text("Take from Camera",style:CustomTextStyle.smallBoldBlackText,),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _showPicker,
      icon: const Icon(Icons.camera, size: 25),
      label: Text('Add Image', style: CustomTextStyle.smallBoldBlackText),
    );

    if (_pickedImageFile != null) {
      content = GestureDetector(
        onTap: _showPicker,
        child: Image.file(
          _pickedImageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      height: 100,
      width: 100,
      alignment: Alignment.center,
      child: content,
    );
  }
}
