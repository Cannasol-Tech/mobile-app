# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/run_stats.dart`
- **Line(s)**: 102-102
- **Method/Widget**: `redStat`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
        redStat(statText: "Overload Alarm: ${formatDuration(alarms.overloadAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.freqLockAlarm == true) && (alarms.freqLockAlarmTime != null) ?  
        redStat(statText: "Freq Lock Alarm: ${formatDuration(alarms.freqLockAlarmTime ?? Duration.zero)}") : Container(),
      ],
              );
      }
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
