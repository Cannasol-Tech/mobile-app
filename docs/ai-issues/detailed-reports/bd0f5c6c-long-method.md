# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/methods.dart`
- **Line(s)**: 93-93
- **Method/Widget**: `isPortrait`

## Description


## Why This Matters


## Current Code
```dart
}

bool isPortrait(ctx) {
    Orientation orient = MediaQuery.of(ctx).orientation;
    return (orient == Orientation.portrait);
}
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
