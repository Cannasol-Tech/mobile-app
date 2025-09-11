# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/dialogs/terms_and_conditions.dart`
- **Line(s)**: 70-70
- **Method/Widget**: `TextStyle`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
        // width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.6,
          width: (scalar.value) * ui.size.displayWidth * 0.9,
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
