# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_classes/status_message.dart`
- **Line(s)**: 10-10
- **Method/Widget**: `fromDevice`

## Description


## Why This Matters


## Current Code
```dart
  Color color = Colors.grey;

  StatusMessage.fromDevice(Device device){
  final Map<int, String> stateToStatusMap = {
      RESET : "Resetting",
      INIT  : "System Ready",
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
