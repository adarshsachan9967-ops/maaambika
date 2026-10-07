import 'package:flutter/material.dart';

class QuestionsStep extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;
  final Function(int questionIndex, int optionIndex) onAnswerSelected;
  final VoidCallback onContinue;

  const QuestionsStep({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length + 1,
      itemBuilder: (ctx, idx) {
        if (idx == questions.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onContinue,
              child: const Text('Calculate Resale Quote', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          );
        }

        final q = questions[idx];
        final options = List<Map<String, dynamic>>.from(q['options'] ?? []);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q['question'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                ...List.generate(options.length, (optIdx) {
                  final opt = options[optIdx];
                  return RadioListTile<int>(
                    value: optIdx,
                    groupValue: selectedAnswers[idx],
                    activeColor: const Color(0xFF059669),
                    title: Text(opt['text'] ?? '', style: const TextStyle(fontSize: 13)),
                    onChanged: (val) {
                      if (val != null) onAnswerSelected(idx, val);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
