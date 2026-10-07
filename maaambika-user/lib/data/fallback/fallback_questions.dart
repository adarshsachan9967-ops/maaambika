class FallbackQuestions {
  static final List<Map<String, dynamic>> _defaultQuestions = [
    {
      'question': 'Does the device turn on and work normally?',
      'options': [
        {'text': 'Yes, perfectly fine', 'value': 0},
        {'text': 'Turns on with minor issues', 'value': -3000},
        {'text': 'Does not turn on / Dead', 'value': -15000},
      ],
    },
    {
      'question': 'What is the condition of the screen / display?',
      'options': [
        {'text': 'Flawless (No scratches or lines)', 'value': 0},
        {'text': 'Minor minor scratches', 'value': -2000},
        {'text': 'Cracked glass or display lines', 'value': -8000},
      ],
    },
    {
      'question': 'What is the physical body condition?',
      'options': [
        {'text': 'Like New / Flawless', 'value': 0},
        {'text': 'Minor signs of regular use', 'value': -1500},
        {'text': 'Dents or heavy scratches', 'value': -4500},
      ],
    },
    {
      'question': 'Do you have original bill and box?',
      'options': [
        {'text': 'Original Box & Bill available', 'value': 1000},
        {'text': 'Only Box or Only Bill', 'value': 0},
        {'text': 'No accessories / Only device', 'value': -1000},
      ],
    },
  ];

  static List<Map<String, dynamic>> getQuestions(String categoryId) {
    return List<Map<String, dynamic>>.from(_defaultQuestions);
  }
}
