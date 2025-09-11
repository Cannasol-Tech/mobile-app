# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 18-18
- **Method/Widget**: `Unknown`

## Description
Global variable "navigatorKey" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
typedef CurrentUser = User?;

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


```

## Suggested Fix
Move "navigatorKey" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "navigatorKey"
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
