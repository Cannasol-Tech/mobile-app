# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/confirm_button.dart`
- **Line(s)**: 58-58
- **Method/Widget**: `withAlpha`

## Description


## Why This Matters


## Current Code
```dart
        foregroundColor: Colors.black,
        backgroundColor: widget.color,
        elevation: 20 - 10 * scalar.value,
        animationDuration: const Duration(seconds: 1),
      ),
      // Wrap the text in a FittedBox to ensure it scales down when needed.
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
