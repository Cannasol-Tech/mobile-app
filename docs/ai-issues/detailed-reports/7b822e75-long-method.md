# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/sign_in.dart`
- **Line(s)**: 75-75
- **Method/Widget**: `catch`

## Description


## Why This Matters


## Current Code
```dart
      userHandler.setFCMToken(token);
      fbApi.setTokenRefreshCallback(userHandler.setFCMToken);
    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found'){
          showErrorMessage('User not found!');
        } else if (e.code == 'wrong-password') {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
