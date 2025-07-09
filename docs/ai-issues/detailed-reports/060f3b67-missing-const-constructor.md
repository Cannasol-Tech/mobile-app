# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/run_stats.dart`
- **Line(s)**: 98-98
- **Method/Widget**: `redStat`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
        redStat(statText: "Temp Alarm: ${formatDuration(alarms.tempAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.pressureAlarm == true) && (alarms.pressureAlarmTime != null) ?  
        redStat(statText: "Pressure Alarm: ${formatDuration(alarms.pressureAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.overloadAlarm == true) && (alarms.overloadAlarmTime != null) ?  
        redStat(statText: "Overload Alarm: ${formatDuration(alarms.overloadAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.freqLockAlarm == true) && (alarms.freqLockAlarmTime != null) ?  
```

## Suggested Fix
Add const keyword to widget constructors where possible.

## Implementation Steps
1. Add const keyword before the widget constructor
2. Ensure all parameters are const or final
3. Verify no mutable state is being passed

## Additional Resources
- https://flutter.dev/docs/perf/rendering/best-practices#use-const-widgets

## Estimated Effort
15-30 minutes

## Analysis Confidence
High
