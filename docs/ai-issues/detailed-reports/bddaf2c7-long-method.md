# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/user_handler.dart`
- **Line(s)**: 159-159
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  Future<bool> doesEmailExist(String email) async {
    dynamic userReference = FirebaseDatabase.instance.ref('/users');
    if (userReference != null){
      dynamic userSnapshot = await userReference.get();
      for (dynamic user in userSnapshot.children){
        dynamic emailSnapshot = await user.child('/email').ref.get();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
