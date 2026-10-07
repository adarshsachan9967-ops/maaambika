import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/api_constants.dart';
import '../../app.dart';

class Helpers {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) {
      showErrorSnackbar('Error', 'Invalid phone number');
      return;
    }
    final Uri phoneUri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        showErrorSnackbar('Error', 'Could not open phone dialer');
      }
    } catch (e) {
      showErrorSnackbar('Error', 'Could not open phone dialer');
    }
  }

  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        showErrorSnackbar('Error', 'Could not launch link');
      }
    } catch (e) {
      showErrorSnackbar('Error', 'Could not launch link');
    }
  }

  static void showSuccessSnackbar(String title, String message) {
    partnerScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    partnerScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showErrorSnackbar(String title, String message) {
    partnerScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    partnerScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static String capitalize(String value) {
    if (value.trim().isEmpty) return '';
    final trimmed = value.trim();
    return trimmed.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  static String getSanitizedImageUrl(String? url, {String fallbackUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWIGUMRFAXhILyTNE3tkAaik5wLpIYNrHszRUxCUNaLGZieka29wYF8L4f4VEzHRk&s&ec=121924526'}) {
    if (url == null || url.trim().isEmpty) {
      return fallbackUrl;
    }
    String sanitized = url.trim();
    if (sanitized.contains('localhost') || sanitized.contains('127.0.0.1')) {
      sanitized = sanitized.replaceFirst(
        RegExp(r'https?://(localhost|127\.0\.0\.1)(:\d+)?'),
        ApiConstants.serverUrl,
      );
    } else if (sanitized.startsWith('/')) {
      sanitized = '${ApiConstants.serverUrl}$sanitized';
    } else if (!sanitized.startsWith('http://') && !sanitized.startsWith('https://') && !sanitized.startsWith('data:image')) {
      sanitized = '${ApiConstants.serverUrl}/$sanitized';
    }
    return sanitized;
  }
}
