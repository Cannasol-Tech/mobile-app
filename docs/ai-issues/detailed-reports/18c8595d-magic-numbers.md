# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 88-88
- **Method/Widget**: `now`

## Description


## Why This Matters


## Current Code
```dart

      latch = Timer.periodic(const Duration(seconds: 1), (timer) {
        int runSeconds = (DateTime.now().millisecondsSinceEpoch ~/ 1000) - alarmStartTime!.inSeconds;
        duration = Duration(seconds: runSeconds);  
      });
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
