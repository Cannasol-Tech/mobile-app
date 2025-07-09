# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 51-51
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      return int.parse(value);
    }
    else if (value is double) {
      return value.round();
    }
    return value;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
