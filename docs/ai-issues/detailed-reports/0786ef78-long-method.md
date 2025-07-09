# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 80-80
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        properties[name]?.ref.set(1);
      }
      else if (value == false || value == 0) {
        properties[name]?.ref.set(0);
      }
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
