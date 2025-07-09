# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/run_page.dart`
- **Line(s)**: 79-79
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      context.read<SystemIdx>().increment();
    } 
    else if (swipeDir == Direction.right) {
      context.read<SystemIdx>().decrement();
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
