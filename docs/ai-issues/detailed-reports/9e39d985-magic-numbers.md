# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/sys_val_toggle.dart`
- **Line(s)**: 18-18
- **Method/Widget**: `fromRGBO`

## Description


## Why This Matters


## Current Code
```dart
            heroTag: tag,
            foregroundColor: Colors.black,
            backgroundColor: (activeDevice != null) ? sysVal.value ? const Color.fromRGBO(0, 198, 50, 100) : const Color.fromRGBO(200, 0, 0, 100) : const Color.fromRGBO(200, 0, 0, 100),
            child:(activeDevice != null) ? sysVal.value ? const Text("On") : const Text("Off") : const Text("Off"),
            onPressed: (){
              if (activeDevice != null){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
