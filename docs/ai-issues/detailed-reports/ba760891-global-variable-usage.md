# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 26-26
- **Method/Widget**: `SystemIdx`

## Description
Global variable "maxValue" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart

  final int minValue = 0;
final int maxValue = 2;

  void increment() {
    if (value < maxValue) {
```

## Suggested Fix
Move "maxValue" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "maxValue"
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
