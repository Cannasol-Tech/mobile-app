# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/end_page.dart`
- **Line(s)**: 28-28
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
                              state: model.activeDevice?.state.state ?? INIT),
    builder: (_xX, data, Xx_) {
      if (data.state != FINISHED) {
        return const StartPage();  
      }
      else {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
