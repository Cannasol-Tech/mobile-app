# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/sign_in.dart`
- **Line(s)**: 78-78
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        if (e.code == 'user-not-found'){
          showErrorMessage('User not found!');
        } else if (e.code == 'wrong-password') {
          showErrorMessage('Incorrect password');
        }
        else {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
