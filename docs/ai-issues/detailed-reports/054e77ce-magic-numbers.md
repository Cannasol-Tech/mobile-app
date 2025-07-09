# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/confirm_button.dart`
- **Line(s)**: 52-52
- **Method/Widget**: `circular`

## Description


## Why This Matters


## Current Code
```dart
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor:
            widget.shadowColor.withAlpha((100 + 80 * scalar.value).toInt()),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
