# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/pages/reset_password.dart`
- **Line(s)**: 66-66
- **Method/Widget**: `systemAppBar`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
              constraints: BoxConstraints(
                maxWidth: ui.size.maxWidth, 
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
