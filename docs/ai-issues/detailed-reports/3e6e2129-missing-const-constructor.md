# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/freq_lock_display.dart`
- **Line(s)**: 37-37
- **Method/Widget**: `SizedBox`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
                children: <Widget> [
                  const SizedBox(height: 22.5),
                  Text('Hz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: sonicAlarm? Color.fromRGBO(255, 255, 255, textOpacity) : Colors.white,
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
