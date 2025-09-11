# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/shared/constants.dart`
- **Line(s)**: 41-41
- **Method/Widget**: `Unknown`

## Description
Global variable "TAC_PATH" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
/* Documents */
const String PP_PATH = "assets/documents/privacy_policy.md";
const String TAC_PATH = "assets/documents/terms_and_conditions.md";

// const Color originalConfirmButtonColor = Color.fromARGB(156, 95, 103, 97);
Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
```

## Suggested Fix
Move "TAC_PATH" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "TAC_PATH"
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
