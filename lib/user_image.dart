import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key, required this.onUpdateImage});
  final void Function(File updatedImage) onUpdateImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              selectedImage != null ? FileImage(selectedImage!) : null,
        ),
        TextButton.icon(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  selectedImage = File(image.path);
                });
                widget.onUpdateImage(selectedImage!);
              }
            },
            icon: Icon(Icons.image),
            label: Text('add image'))
      ],
    );
  }
}
