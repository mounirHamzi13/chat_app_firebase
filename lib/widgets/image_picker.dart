import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(XFile? image) seImage;
  UserImagePicker(this.seImage, {super.key});

  @override
  State<UserImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<UserImagePicker> {
  XFile? pickedImage; // Allow null values for pickedImage

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150 ,maxWidth: 150);
    setState(() {
      pickedImage = image;
    });
    widget.seImage(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? image;
    if (pickedImage != null) { 
      image = FileImage(File(pickedImage!.path)) ;
    } else {
      image = NetworkImage('https://i.pinimg.com/236x/9e/83/75/9e837528f01cf3f42119c5aeeed1b336.jpg') ;
    }
    return Column(
      children: [
        CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: image ,
            ),
        TextButton.icon(
          label: const Text(
            'Add a profile picture',
            style: TextStyle(color: Colors.pink),
          ),
          icon: const Icon(
            Icons.image,
            color: Colors.pink,
          ),
          onPressed: pickImage,
          // style: TextButton.styleFrom(
          //   textStyle: const TextStyle(color: Colors.pink)
          // )
        )
      ],
    );
  }
}
