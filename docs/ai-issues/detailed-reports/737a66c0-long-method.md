# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 148-148
- **Method/Widget**: `then`

## Description


## Why This Matters


## Current Code
```dart
  void _handlePress(BuildContext context) {
    _ctrl150Msec.forward(from: 0.0)
    .then((_) {
      _ctrl150Msec.reverse()
      .then((_) {
        if (w.display) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
