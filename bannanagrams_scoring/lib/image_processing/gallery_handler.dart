import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHandler {
  final ImagePicker _picker = ImagePicker();
  
  /// Requests gallery permission and picks an image
  Future<File?> pickImageFromGallery(BuildContext context) async {
    // Check and request permission
    if (!await _requestGalleryPermission(context)) {
      return null;
    }
    
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
      _showErrorDialog(context, 'Failed to pick image: $e');
      return null;
    }
  }
  
  /// Requests gallery permissions, showing rationale if needed
  Future<bool> _requestGalleryPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }
    }
    
    // Show rationale if permission permanently denied
    if (status.isPermanentlyDenied) {
      _showPermissionRationaleDialog(context);
      return false;
    }
    
    return false;
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
  
  /// Shows permission rationale dialog
  void _showPermissionRationaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gallery Access Required'),
          content: const Text(
            'Bannagram Scorer needs access to your photos to select game images for scoring. '
            'Please enable gallery access in your device settings.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}