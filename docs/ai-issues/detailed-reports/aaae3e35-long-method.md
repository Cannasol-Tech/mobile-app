# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/methods.dart`
- **Line(s)**: 82-82
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
List<int> range(int number, [int? secondNumber, int? step]){
  if (secondNumber != null) {
    if (step != null) {
      return yieldRange(number, secondNumber, step).toList();
    }
    return yieldRange(number, secondNumber).toList();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
