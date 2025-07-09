# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/dialogs/terms_and_conditions.dart`
- **Line(s)**: 40-40
- **Method/Widget**: `play`

## Description


## Why This Matters


## Current Code
```dart
  void initState() {
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1.0).animate(scalarController);
    _loadTermsAndConditions();
    super.initState();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
