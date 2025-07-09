# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/api/firebase_api.dart`
- **Line(s)**: 49-49
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    String? token = await getToken();

    if (token == null) {
        log.info("ERROR -> Error retrieving FCM token.");
    }   

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
