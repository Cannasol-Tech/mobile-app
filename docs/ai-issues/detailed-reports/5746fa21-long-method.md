# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 151-151
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      _ctrl150Msec.reverse()
      .then((_) {
        if (w.display) {
          final sys = context.read<SystemIdx>();
          if (w.pDirection == Direction.left && sys.value != sys.minValue) {
            sys.decrement();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
