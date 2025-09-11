# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/sys_val_toggle.dart`
- **Line(s)**: 21-21
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
            child:(activeDevice != null) ? sysVal.value ? const Text("On") : const Text("Off") : const Text("Off"),
            onPressed: (){
              if (activeDevice != null){
                sysVal.value = !sysVal.value;
                setMethod(sysVal.value);
              }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
