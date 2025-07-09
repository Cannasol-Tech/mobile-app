# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_handler.dart`
- **Line(s)**: 156-156
- **Method/Widget**: `getIgnoredAlarmNames`

## Description


## Why This Matters


## Current Code
```dart
  }

  List<String> getIgnoredAlarmNames(){
     return alarms.asMap().entries.where((e) => e.value)
    .map((e) => getAlarmName(e.key)).toList();
  }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
