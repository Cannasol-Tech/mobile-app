# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/warn_icon.dart`
- **Line(s)**: 10-10
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

String warnText(String paramName, minVal, maxVal, units) {
  if (minVal != null){
    return "minimum value of $minVal $units!"; 
  }
  else if (maxVal != null) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
