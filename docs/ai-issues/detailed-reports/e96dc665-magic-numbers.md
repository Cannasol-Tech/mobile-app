# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/settings_page.dart`
- **Line(s)**: 103-103
- **Method/Widget**: `Text`

## Description


## Why This Matters


## Current Code
```dart
                        dense: true,
                        leading: const Icon(Icons.key),
                        title: const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
