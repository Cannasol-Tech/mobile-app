# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/pages/home/end_page.dart`
- **Line(s)**: 42-42
- **Method/Widget**: `Container`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(alignment: Alignment.center, child: Image.asset("assets/images/BigIcon.png"),),
                ],
            ),),
                Row(
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
