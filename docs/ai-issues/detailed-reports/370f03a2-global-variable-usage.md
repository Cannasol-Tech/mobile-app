# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 37-37
- **Method/Widget**: `Unknown`

## Description
Global variable "LOCK_CLOSE" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
const String WARN_ICON  = "assets/images/warn.jpg";
const String LOCK_OPEN  = "assets/images/padlock_open.avif";
const String LOCK_CLOSE = "assets/images/padlock_close.png";

/* Documents */
const String PP_PATH = "assets/documents/privacy_policy.md";
```

## Suggested Fix
Move "LOCK_CLOSE" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "LOCK_CLOSE"
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
