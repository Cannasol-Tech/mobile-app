# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/dropdown_menu.dart`
- **Line(s)**: 49-49
- **Method/Widget**: `fromRGBO`

## Description


## Why This Matters


## Current Code
```dart
                          // labelText: "Select Device: ",
                          filled: true,
                          fillColor: Color.fromRGBO(0, 0, 150, 0.05),
                        ),
                        value: setName,
                        items: getDropDownItems(value.devices, watchedDeviceNames, styles),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
