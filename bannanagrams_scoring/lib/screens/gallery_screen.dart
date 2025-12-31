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
      appBar: AppBar(
        title: const Text('Bannagram Scorer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 246, 244, 230),
                    ),
                    child: const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _isLoading ? null : _selectImage,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFFFF5C2),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 246, 244, 230),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const Icon(Icons.photo_library, size: 40),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'select from gallery',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_isLoading)
                      Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 8.0),
                          Text(
                            'Processing image...',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
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