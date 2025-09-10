import 'package:flutter/material.dart';

/// A customizable confirmation dialog widget
class ConfirmDialog extends StatelessWidget {
  /// Creates a confirmation dialog
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  /// The title of the dialog
  final String title;

  /// The message content of the dialog
  final String message;

  /// The text for the confirm button
  final String confirmText;

  /// The text for the cancel button
  final String cancelText;

  /// Whether this is a destructive action (affects styling)
  final bool isDestructive;

  /// Optional callback when confirm is pressed
  final VoidCallback? onConfirm;

  /// Optional callback when cancel is pressed
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: isDestructive
          ? const Icon(
              Icons.warning,
              color: Colors.red,
              size: 32,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          child: Text(
            confirmText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDestructive ? Colors.red : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Legacy function for backward compatibility
/// @deprecated Use ConfirmDialog widget instead
confirmDialog(context, confirmMethod, promptText) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Notice!"),
    content: Text("Are you sure you want to $promptText?"),
    actions: [
      TextButton(
        child: const Text("Yes"),
        onPressed: () {
          confirmMethod();
          Navigator.of(context).pop(); // dismiss dialog
        },
      ),
      TextButton(
        child: const Text("No"),
        onPressed: () {
          Navigator.of(context).pop(); // dismiss dialog
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
