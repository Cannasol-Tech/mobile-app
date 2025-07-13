import 'package:flutter/material.dart';

/// Configuration header style for card titles
TextStyle configHeaderStyle = const TextStyle(
  fontSize: 22, 
  fontWeight: FontWeight.bold, 
  decoration: TextDecoration.underline
);

/// Style for text when no device is selected
const TextStyle noDeviceStyle = TextStyle(
  fontSize: 24, 
  color: Colors.red, 
  fontWeight: FontWeight.bold
);

/// Card title style that uses theme colors
TextStyle cardTitleStyle(BuildContext context) {
  return configHeaderStyle.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
    decoration: TextDecoration.underline,
  );
}

/// Card content text style
TextStyle cardContentStyle(BuildContext context) {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

/// Small text style for secondary information
TextStyle cardSecondaryStyle(BuildContext context) {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
  );
}