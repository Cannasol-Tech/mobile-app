# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 62-62
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      return double.parse("${value.toString()}.0");
    }
    if (value is String){
      return double.parse((double.parse(value)).toStringAsFixed(2));
    }
    double parsedVal = double.parse(value.toStringAsFixed(2));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
