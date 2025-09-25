import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';

class OpenAppSettingsDialog extends StatelessWidget {
  const OpenAppSettingsDialog({
    super.key,
    required this.onConfirm,
    required this.message,
  });

  final Future<void> Function() onConfirm;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permission Required'),
      content: Text(message),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.mulish(
              color: context.onPrimaryColor.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          },
          child: Text(
            'Open Settings',
            style: GoogleFonts.mulish(
              color: context.onPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
