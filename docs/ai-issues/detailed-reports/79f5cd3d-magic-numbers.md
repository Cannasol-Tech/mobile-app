# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/pump_control_config.dart`
- **Line(s)**: 23-23
- **Method/Widget**: `fromLTRB`

## Description


## Why This Matters


## Current Code
```dart
        void Function(bool) setter = context.read<SystemDataModel>().activeDevice!.config.setPumpControl;
        return SwitchListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
          dense: true,
          title: const Text('    Pump Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          value: (context.read<SystemDataModel>().activeDevice != null) ? pumpControl.value : false,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
