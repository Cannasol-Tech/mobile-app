# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/resume_button.dart`
- **Line(s)**: 23-23
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
                height: ui.size.bottomButtonHeight,
                child: ConfirmButton(
                  color: const Color.fromARGB(95, 3, 251, 197),
                  shadowColor: const Color.fromARGB(255, 2, 99, 78),
                  confirmMethod: context.read<SystemDataModel>().activeDevice?.config.resumeRun as Function,
                  confirmText: 'wish to resume',
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
