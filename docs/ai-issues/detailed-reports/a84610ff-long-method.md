# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/config_handler.dart`
- **Line(s)**: 115-115
- **Method/Widget**: `setEnableCoolDown`

## Description


## Why This Matters


## Current Code
```dart
  }

  void setEnableCoolDown(bool enabled) {
    dynamic property = getPropertyByVariableName('enable_cooldown');
    if (property != null){
      property.setValue(enabled);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
