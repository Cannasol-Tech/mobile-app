# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/run_stats.dart`
- **Line(s)**: 94-94
- **Method/Widget**: `redStat`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
        runStat(statText: "Set Temp: $currSetTemp \u2103", color: setTempColor(state)),
        (alarms.flowAlarm == true) && (alarms.flowAlarmTime != null) ?
        redStat(statText: "Flow Alarm: ${formatDuration(alarms.flowAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.tempAlarm == true) && (alarms.tempAlarmTime != null) ?
        redStat(statText: "Temp Alarm: ${formatDuration(alarms.tempAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.pressureAlarm == true) && (alarms.pressureAlarmTime != null) ?  
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
