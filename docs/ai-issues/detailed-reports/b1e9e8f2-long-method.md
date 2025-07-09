# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/current_run_page.dart`
- **Line(s)**: 39-39
- **Method/Widget**: `switch`

## Description


## Why This Matters


## Current Code
```dart
      shouldRebuild: (previous, next) => rebuildFilter(previous, next), 
      builder: (_, state, __) {
        switch (state) {
          case INIT:     return const StartPage();
          case WARM_UP:  return const RunPage();
          case RUNNING:  return const RunPage();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
