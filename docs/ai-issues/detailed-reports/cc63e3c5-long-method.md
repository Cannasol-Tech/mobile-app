# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 291-291
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  void updateAlarmFlash() {
    if(_activeDevice != null) {
      if (_almCount < 2) {
        _almCount += 1;
      }
      else {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
