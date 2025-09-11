# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 16-16
- **Method/Widget**: `Unknown`

## Description
Global variable "SHOW_TANK" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
const int SHOW_SONICATOR = 0;
const int SHOW_PUMP  = 1;
const int SHOW_TANK  = 2;

/* Page Titles */
const String RUN_TITLE = "System Running";
```

## Suggested Fix
Move "SHOW_TANK" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "SHOW_TANK"
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
