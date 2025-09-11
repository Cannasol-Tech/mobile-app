# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/UserInterface/icons.dart`
- **Line(s)**: 13-13
- **Method/Widget**: `ArrowIcon`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
  double get shadowOffsetHalf => shadowOffset*0.5;

  const ArrowIcon(this.iconData, {super.key, this.shadowOffset=10.0, this.arrowShade=Colors.transparent}) : super(iconData);
    @override get shadows => [
      // BoxShadow(
      //   // blurStyle: BlurStyle.solid,
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
