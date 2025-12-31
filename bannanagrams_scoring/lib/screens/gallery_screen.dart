import 'dart:io';
import 'package:flutter/material.dart';
import '../image_processing/gallery_handler.dart';
import '../services/ocr_service.dart';
import '../services/scoring_service.dart';
import 'results_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryHandler _galleryHandler = GalleryHandler();
  final OCRService _ocrService = OCRService();
  final ScoringService _scoringService = ScoringService();
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
    setState(() {
      _isLoading = true;
    });

    try {
      // Extract letters using OCR
      String detectedLetters = await _ocrService.extractLetters(imageFile);
      
      // Calculate score
      int totalScore = _scoringService.calculateScore(detectedLetters);
      
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to results screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              imageFile: imageFile,
              detectedLetters: detectedLetters,
              totalScore: totalScore,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            if (_selectedImage != null)
              Expanded(
                flex: 3,
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.contain,
                ),
              )
            else
              const Expanded(
                flex: 3,
                child: Text(
                  'No image selected',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ),
            const Expanded(flex: 1, child: SizedBox()),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              InkWell(
                onTap: _selectImage,
                child: const Icon(Icons.photo_library, size: 40),
              ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}