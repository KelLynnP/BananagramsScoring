import 'dart:io';
import 'package:flutter/material.dart';
import '../services/scoring_service.dart';

class ResultsScreen extends StatelessWidget {
  final File imageFile;
  final String detectedLetters;
  final int totalScore;

  const ResultsScreen({
    Key? key,
    required this.imageFile,
    required this.detectedLetters,
    required this.totalScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoringService = ScoringService();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Total Score',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$totalScore',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${detectedLetters.length} tiles',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                height: 200,
                width: 300,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: detectedLetters.split('').map((letter) {
                  int value = scoringService.getLetterValue(letter);
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.camera_alt_outlined, size: 40),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

