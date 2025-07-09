# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/banners.dart`
- **Line(s)**: 38-38
- **Method/Widget**: `play`

## Description


## Why This Matters


## Current Code
```dart
    super.initState();
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1000.0).animate(scalarController);
  }
  @override
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
