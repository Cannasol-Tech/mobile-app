# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/buttons/resume_button.dart`
- **Line(s)**: 19-19
- **Method/Widget**: `if`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
      builder: (_x, data, x_) {
        if (data.state == ALARM && data.cleared) {
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
