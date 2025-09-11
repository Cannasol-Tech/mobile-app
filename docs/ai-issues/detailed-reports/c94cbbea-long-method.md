# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_value_input_new.dart`
- **Line(s)**: 78-78
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
          ),
            onFieldSubmitted: (dynamic submittedVal) {
              if (_valid){
                widget.controller.text = submittedVal.replaceAll(' ', '');
                widget.setMethod(submittedVal);
              }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
