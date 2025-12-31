import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Extract all letters from an image file
  Future<String> extractLetters(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Extract all text and filter to only letters A-Z
      StringBuffer letters = StringBuffer();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            String text = element.text;
            // Filter to only alphabetic characters
            for (int i = 0; i < text.length; i++) {
              String char = text[i];
              if (RegExp(r'[A-Za-z]').hasMatch(char)) {
                letters.write(char.toUpperCase());
              }
            }
          }
        }
      }
      
      return letters.toString();
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _textRecognizer.close();
  }
}

