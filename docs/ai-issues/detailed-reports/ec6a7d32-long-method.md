# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/property.dart`
- **Line(s)**: 11-11
- **Method/Widget**: `fromData`

## Description


## Why This Matters


## Current Code
```dart
  FireProperty({required this.name, required this.value, required this.ref});//, required this.type});

  factory FireProperty.fromData(MapEntry data, DatabaseReference ref) {
    FireProperty property = FireProperty(
      ref: ref,
      name: data.key,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
