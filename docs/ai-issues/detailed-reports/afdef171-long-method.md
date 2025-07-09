# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/data.dart`
- **Line(s)**: 80-80
- **Method/Widget**: `namesToIds`

## Description


## Why This Matters


## Current Code
```dart
  }

  List<String> namesToIds(List<String> names){
    List<String> ids = [];
    for (String name in names){
      ids.add(nameIdMap[name]??='');
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
