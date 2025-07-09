# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/page_button.dart`
- **Line(s)**: 49-49
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
      child: FittedBox(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
