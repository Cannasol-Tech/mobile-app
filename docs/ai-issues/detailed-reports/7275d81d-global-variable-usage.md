# Issue: Global Variable Usage

## Severity: Medium

## Category: Architecture

## Location
- **File(s)**: `lib/objects/logger.dart`
- **Line(s)**: 3-3
- **Method/Widget**: `Logger`

## Description
Global variable "log" found. Global variables make code harder to test and maintain.

## Why This Matters
Global state makes debugging difficult, creates tight coupling, and can cause unexpected side effects.

## Current Code
```dart
import 'package:logging/logging.dart';

final Logger log = Logger('AppLogger');

void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
```

## Suggested Fix
Move "log" into a provider, service class, or pass it as a parameter.

## Implementation Steps
1. Create a service class or provider for "log"
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
