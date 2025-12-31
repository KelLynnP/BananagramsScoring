import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryHandler {
  final ImagePicker _picker = ImagePicker();
  
  /// Picks an image from gallery
  /// Note: On iOS 14+, this uses PHPickerViewController which doesn't require permissions
  Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      
      if (pickedFile == null) {
        return null;
      }
      
      return File(pickedFile.path);
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to pick image: $e');
      }
      return null;
    }
  }
  
  /// Shows error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}