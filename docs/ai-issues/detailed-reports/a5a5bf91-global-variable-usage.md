# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 4-4
- **Method/Widget**: `Unknown`

## Description
Global variable "RESET" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
// ignore_for_file: constant_identifier_names

const int RESET = 100;
const int INIT = 0;
const int WARM_UP = 1;
const int RUNNING = 2;
```

## Suggested Fix
Move "RESET" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "RESET"
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
