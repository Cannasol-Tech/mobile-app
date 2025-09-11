# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/components/side_menu.dart`
- **Line(s)**: 168-168
- **Method/Widget**: `SizedBox`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
                  SizedBox(
                    height: 35,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0), 
                      child: PageButton(
                        hero: "AccountSettingsBtn",
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
