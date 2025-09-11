# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/logger.dart`
- **Line(s)**: 5-5
- **Method/Widget**: `setupLogging`

## Description


## Why This Matters


## Current Code
```dart
final Logger log = Logger('AppLogger');

void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((record) {
    // Optionally send logs to external services (e.g., Firebase, Sentry)
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
