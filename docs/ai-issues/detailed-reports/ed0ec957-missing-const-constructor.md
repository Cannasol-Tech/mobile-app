# Issue: Missing Const Constructor

## Severity: Medium

## Category: Performance

## Location
- **File(s)**: `lib/pages/settings_page.dart`
- **Line(s)**: 87-87
- **Method/Widget**: `Row`

## Description
Widget constructor missing const keyword. This prevents Flutter from optimizing widget rebuilds.

## Why This Matters
Non-const widgets are recreated on every build, causing unnecessary performance overhead.

## Current Code
```dart
                      inactiveTrackColor: const Color.fromARGB(74, 25, 23, 23),
                      inactiveThumbColor: const Color.fromARGB(223, 255, 255, 255),
                      title: const Row( children: [Icon(Icons.info), Text('   Email Alert on Alarm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
                        value: Provider.of<SystemDataModel>(context, listen: false).userHandler.emailOnAlarm,
                        onChanged: (swValue) {
                          if (value.userHandler.isEmailVerified() == true){
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
