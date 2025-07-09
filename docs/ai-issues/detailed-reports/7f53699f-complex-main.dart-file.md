# Issue: Complex main.dart File

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 1-107
- **Method/Widget**: `main`

## Description
main.dart contains 107 lines. Large main files can be hard to maintain.

## Why This Matters
Complex main files make app initialization hard to understand and test.

## Current Code
```dart
// main.dart: 107 lines
```

## Suggested Fix
Extract app configuration and setup into separate files.

## Implementation Steps
1. Create app_config.dart for configuration
2. Create dependency_injection.dart for DI setup
3. Move provider setup to providers/app_providers.dart
4. Keep main.dart minimal with just app initialization

## Additional Resources
- https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple

## Estimated Effort
1-2 hours

## Analysis Confidence
Medium
