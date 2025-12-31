class ScoringService {
  static const Map<String, int> _letterValues = {
    'A': 1, 'E': 1, 'I': 1, 'L': 1, 'N': 1, 'O': 1, 'R': 1, 'S': 1, 'T': 1, 'U': 1,
    'D': 2, 'G': 2,
    'B': 3, 'C': 3, 'M': 3, 'P': 3,
    'F': 4, 'H': 4, 'V': 4, 'W': 4, 'Y': 4,
    'K': 5,
    'J': 8, 'X': 8,
    'Q': 10, 'Z': 10,
  };

  /// Calculate total score from a string of letters
  int calculateScore(String letters) {
    int total = 0;
    for (int i = 0; i < letters.length; i++) {
      String letter = letters[i].toUpperCase();
      total += _letterValues[letter] ?? 0;
    }
    return total;
  }

  /// Get point value for a single letter
  int getLetterValue(String letter) {
    return _letterValues[letter.toUpperCase()] ?? 0;
  }

  /// Get breakdown of letters and their values
  Map<String, int> getScoreBreakdown(String letters) {
    Map<String, int> breakdown = {};
    for (int i = 0; i < letters.length; i++) {
      String letter = letters[i].toUpperCase();
      if (_letterValues.containsKey(letter)) {
        breakdown[letter] = _letterValues[letter]!;
      }
    }
    return breakdown;
  }
}

