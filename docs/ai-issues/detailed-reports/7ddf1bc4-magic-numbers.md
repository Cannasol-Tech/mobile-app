# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/data_classes/status_message.dart`
- **Line(s)**: 25-25
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
      WARM_UP : Colors.red,
      RUNNING : Colors.green,
      ALARM : device.state.alarmsCleared ? const Color.fromARGB(255, 221, 218, 218) :Colors.red,
      FINISHED : Colors.green,
      COOL_DOWN : Colors.blue,
    };
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
