# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/settings_page.dart`
- **Line(s)**: 85-85
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
                      activeColor: const Color.fromARGB(150, 255, 255, 255),
                      activeTrackColor: const Color.fromARGB(174, 7, 85, 7),
                      inactiveTrackColor: const Color.fromARGB(74, 25, 23, 23),
                      inactiveThumbColor: const Color.fromARGB(223, 255, 255, 255),
                      title: const Row( children: [Icon(Icons.info), Text('   Email Alert on Alarm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
                        value: Provider.of<SystemDataModel>(context, listen: false).userHandler.emailOnAlarm,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
