# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_value_input_new.dart`
- **Line(s)**: 34-34
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  String? validateInput(String? input) {
    double inVal = double.tryParse(input.toString()) ?? 00.00;
    if (inVal >= widget.minVal && inVal <= widget.maxVal){
      _valid = true;
    }
    else{
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
