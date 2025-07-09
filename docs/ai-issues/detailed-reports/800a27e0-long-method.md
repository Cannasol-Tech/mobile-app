# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/auth_token.dart`
- **Line(s)**: 6-6
- **Method/Widget**: `fromJson`

## Description


## Why This Matters


## Current Code
```dart
  final String tokenType;

  factory AuthToken.fromJson(Map<String, dynamic> data) {
    final accessToken = data['access_token'] as String;
    final tokenType = data['token_type'] as String;
    return AuthToken(accessToken: accessToken, tokenType: tokenType);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
