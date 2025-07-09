# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_value_input_new.dart`
- **Line(s)**: 70-70
- **Method/Widget**: `fromRGBO`

## Description


## Why This Matters


## Current Code
```dart
          isDense: true,
          filled: true,
          fillColor: const Color.fromRGBO(22, 90, 126, 245),
          suffixText: widget.units,
          suffixStyle: widget.units != "L/min" ? const TextStyle(fontSize: 16, color: Colors.black) : const TextStyle(fontSize: 10, color: Colors.black),
            border: const OutlineInputBorder(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
