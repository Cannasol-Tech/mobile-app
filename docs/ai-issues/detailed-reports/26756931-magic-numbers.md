# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/dialogs/terms_and_conditions.dart`
- **Line(s)**: 62-62
- **Method/Widget**: `alphaWhite`

## Description


## Why This Matters


## Current Code
```dart
      UI ui = userInterface(context);
      return AlertDialog(
        backgroundColor: ui.colors.alphaWhite((scalar.value*255).toInt()),
        elevation: scalar.value * _maxElevation,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
