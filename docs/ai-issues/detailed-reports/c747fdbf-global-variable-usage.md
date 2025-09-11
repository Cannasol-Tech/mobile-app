# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 32-32
- **Method/Widget**: `Unknown`

## Description
Global variable "SONIC_PATH" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
const String PUMP_PATH  = "assets/images/pump.png";
const String LARGE_ICON = "assets/images/BigIcon2.png";
const String SONIC_PATH = "assets/images/sonicator2.png";

/* Icons */
const String WARN_ICON  = "assets/images/warn.jpg";
```

## Suggested Fix
Move "SONIC_PATH" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "SONIC_PATH"
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
