# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/buttons/end_button.dart`
- **Line(s)**: 8-8
- **Method/Widget**: `userInterface`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
Widget endButton(context, dataProvider) { 
    UI ui = userInterface(context);
    return SizedBox(
      width: ui.size.bottomButtonWidth,
      height: ui.size.bottomButtonHeight,
      child: ConfirmButton(
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
