# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/side_menu.dart`
- **Line(s)**: 216-216
- **Method/Widget**: `only`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0, left: 20),
                      child: Text('\u00A9 Cannasol Technologies, 2025', 
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 9
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
