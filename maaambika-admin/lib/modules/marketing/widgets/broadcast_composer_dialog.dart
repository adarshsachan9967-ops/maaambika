import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BroadcastComposerDialog extends StatefulWidget {
  final Function(String title, String body) onSend;

  const BroadcastComposerDialog({
    super.key,
    required this.onSend,
  });

  static Future<void> show(BuildContext context, Function(String, String) onSend) {
    return showDialog(
      context: context,
      builder: (ctx) => BroadcastComposerDialog(onSend: onSend),
    );
  }

  @override
  State<BroadcastComposerDialog> createState() => _BroadcastComposerDialogState();
}

class _BroadcastComposerDialogState extends State<BroadcastComposerDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: 'Festive Flash Deal!');
    _bodyCtrl = TextEditingController(
      text: 'Extra ₹1,500 exchange bonus on all iPhones today only. Tap to sell!',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.campaign, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Push Notification Broadcast',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Notification Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Message Body',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () {
            final title = _titleCtrl.text.trim();
            final body = _bodyCtrl.text.trim();
            Navigator.pop(context);
            if (title.isNotEmpty && body.isNotEmpty) {
              widget.onSend(title, body);
            }
          },
          child: const Text(
            'Dispatch Push',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
