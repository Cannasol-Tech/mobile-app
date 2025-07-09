# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 82-82
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        registerDeviceController.text = newDeviceData.id.toString();     
      }
      if (newState.state != activeState.state){
        stateController.text = newState.state.toString();
      }

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
