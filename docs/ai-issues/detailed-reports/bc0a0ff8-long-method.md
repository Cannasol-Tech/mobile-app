# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_value_input_new.dart`
- **Line(s)**: 51-51
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_valid){
              widget.setMethod(widget.controller.text);
            }
            else {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
