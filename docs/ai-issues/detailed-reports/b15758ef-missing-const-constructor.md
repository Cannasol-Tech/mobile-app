# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 190-190
- **Method/Widget**: `Duration`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
              curve: Curves.bounceInOut,
              builder: (BuildContext context, Color? color, Widget? child) {
                return ArrowIcon(
              w.arrowIconData, 
              shadowOffset: startShadowOffset*_animationScalor.value,
              arrowShade:  (w.pAlarmActive(alarms) == true) ? 
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
