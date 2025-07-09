# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/api/firebase_api.dart`
- **Line(s)**: 28-28
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  Future<void> initNotifications() async {

    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
