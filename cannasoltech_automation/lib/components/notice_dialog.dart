import 'package:flutter/material.dart';

/// Enum defining different types of notices
enum NoticeType {
  info,
  success,
  warning,
  error,
}

/// A customizable notice dialog widget
class NoticeDialog extends StatelessWidget {
  /// Creates a notice dialog
  const NoticeDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.type = NoticeType.info,
    this.onPressed,
  });

  /// The title of the dialog
  final String title;

  /// The message content of the dialog
  final String message;

  /// The text for the action button
  final String buttonText;

  /// The type of notice (affects icon and colors)
  final NoticeType type;

  /// Optional callback when button is pressed
  final VoidCallback? onPressed;

  /// Get the appropriate icon for the notice type
  IconData get _getIcon {
    switch (type) {
      case NoticeType.success:
        return Icons.check_circle;
      case NoticeType.warning:
        return Icons.warning;
      case NoticeType.error:
        return Icons.error;
      case NoticeType.info:
        return Icons.info;
    }
  }

  /// Get the appropriate color for the notice type
  Color get _getColor {
    switch (type) {
      case NoticeType.success:
        return Colors.green;
      case NoticeType.warning:
        return Colors.orange;
      case NoticeType.error:
        return Colors.red;
      case NoticeType.info:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        _getIcon,
        color: _getColor,
        size: 32,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            onPressed?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// Legacy function for backward compatibility
/// @deprecated Use NoticeDialog widget instead
noticeDialog(context, noticeTitle, noticeContent) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return NoticeDialog(
        title: noticeTitle,
        message: noticeContent,
      );
    },
  );
}
