# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/methods.dart`
- **Line(s)**: 44-44
- **Method/Widget**: `showSnack`

## Description


## Why This Matters


## Current Code
```dart
  }

  void showSnack(BuildContext context, SnackBar snack) {
    hideSnack(context);
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
