# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/data.dart`
- **Line(s)**: 90-90
- **Method/Widget**: `for`

## Description


## Why This Matters


## Current Code
```dart
    List<String> idsToNames(List<String> ids){
    List<String> names = [];
    for (String deviceId in ids){
      names.add(idNameMap[deviceId]??='');
    }
    return names;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
