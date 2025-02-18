import 'dart:io';
import 'package:flutter/material.dart';
import '../image_processing/gallery_handler.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryHandler _galleryHandler = GalleryHandler();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _selectImage() async {
    setState(() {
      _isLoading = true;
    });
    
    final File? imageFile = await _galleryHandler.pickImageFromGallery(context);
    
    setState(() {
      _selectedImage = imageFile;
      _isLoading = false;
    });
    
    if (imageFile != null) {
      // Process the image or navigate to results
      _processImage(imageFile);
    }
  }
  
  Future<void> _processImage(File imageFile) async {
    // This is where you'd call your OCR service
    // For now, we'll just navigate to results with the image path
    
    // Example navigation:
    Navigator.pushNamed(
      context, 
      '/results',
      arguments: {'imagePath': imageFile.path}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bannagram Scorer'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Select from Gallery'),
                      onPressed: _isLoading ? null : _selectImage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_isLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}