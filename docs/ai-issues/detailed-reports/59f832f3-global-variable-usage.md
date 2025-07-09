# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 26-26
- **Method/Widget**: `Unknown`

## Description
Global variable "LOG_FILE_PATH" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart

/* Logging */
const String LOG_FILE_PATH = "log.txt";

/* System Elements */
const String TANK_PATH  = "assets/images/Tank.png";
```

## Suggested Fix
Move "LOG_FILE_PATH" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "LOG_FILE_PATH"
2. Inject the service where needed using Provider or dependency injection
3. Remove the global variable declaration
4. Update all references to use the injected service

## Additional Resources
- https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple
- https://pub.dev/packages/provider

## Estimated Effort
15-30 minutes

## Analysis Confidence
High
