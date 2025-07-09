# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/methods.dart`
- **Line(s)**: 15-15
- **Method/Widget**: `padZeros`

## Description


## Why This Matters


## Current Code
```dart
    // "${d.toStringAsFixed(decimalPlaces).replaceFirst(RegExp(r'\.?0*$'), '')} $units";

String padZeros(int number, int totalLength) {
  return number.toString().padLeft(totalLength, '0');
}

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
