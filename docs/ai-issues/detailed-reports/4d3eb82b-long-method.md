# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/run_page.dart`
- **Line(s)**: 56-56
- **Method/Widget**: `switch`

## Description


## Why This Matters


## Current Code
```dart
          return noDeviceDisplay();
        } else {
          switch (state) {
            case INIT     : return const StartPage();
            case FINISHED : return const EndPage();
            default: return Scaffold(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
