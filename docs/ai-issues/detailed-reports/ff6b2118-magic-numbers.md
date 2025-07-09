# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/confirm_button.dart`
- **Line(s)**: 55-55
- **Method/Widget**: `withAlpha`

## Description


## Why This Matters


## Current Code
```dart
        ),
        shadowColor:
            widget.shadowColor.withAlpha((100 + 80 * scalar.value).toInt()),
        foregroundColor: Colors.black,
        backgroundColor: widget.color,
        elevation: 20 - 10 * scalar.value,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
