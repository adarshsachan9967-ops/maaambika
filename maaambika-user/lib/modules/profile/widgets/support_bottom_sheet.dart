import 'package:flutter/material.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF059669)),
            title: const Text('Call Customer Support', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('+91 98200 11223 (10 AM - 8 PM)'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF25D366)),
            title: const Text('WhatsApp Live Chat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Instant answers to buyback & exchange questions'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF4F46E5)),
            title: const Text('Email Support', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('support@maaambika.com'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
