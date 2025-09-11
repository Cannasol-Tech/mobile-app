# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/register_page.dart`
- **Line(s)**: 96-96
- **Method/Widget**: `validateConfirmPassword`

## Description


## Why This Matters


## Current Code
```dart
  }

  String? validateConfirmPassword(String? input) {
    if (confirmPasswordController.text.length < 8 && confirmPasswordController.text.isNotEmpty){
        return "Password must be longer than 8 characters.";
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
