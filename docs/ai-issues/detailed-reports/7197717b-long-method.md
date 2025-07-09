# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/alarm_notification.dart`
- **Line(s)**: 71-71
- **Method/Widget**: `getIgnAlarmName`

## Description


## Why This Matters


## Current Code
```dart
  }

  String? getIgnAlarmName(String alarmName){
    if (alarmName.contains('Flow')){return 'ign_flow_alarm';}
    if (alarmName.contains('Temperature')){return 'ign_temp_alarm';}
    if (alarmName.contains('Pressure')){return 'ign_pressure_alarm';}
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
