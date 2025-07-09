# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/page_button.dart`
- **Line(s)**: 46-46
- **Method/Widget**: `withAlpha`

## Description


## Why This Matters


## Current Code
```dart
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: widget.shadowColor.withAlpha((100 + 80 * scalar.value).toInt()),
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
