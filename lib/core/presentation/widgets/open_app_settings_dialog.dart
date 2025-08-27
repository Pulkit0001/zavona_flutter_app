import 'package:flutter/material.dart';

class OpenAppSettingsDialog extends StatelessWidget {
  const OpenAppSettingsDialog({super.key, required this.onConfirm, required this.message});

  final Future<void> Function() onConfirm;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permission Required'),
      content: Text(
        message,
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
