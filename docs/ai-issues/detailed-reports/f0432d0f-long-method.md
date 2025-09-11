# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 150-150
- **Method/Widget**: `then`

## Description


## Why This Matters


## Current Code
```dart
    .then((_) {
      _ctrl150Msec.reverse()
      .then((_) {
        if (w.display) {
          final sys = context.read<SystemIdx>();
          if (w.pDirection == Direction.left && sys.value != sys.minValue) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
