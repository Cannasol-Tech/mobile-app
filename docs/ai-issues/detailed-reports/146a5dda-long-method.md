# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/no_device.dart`
- **Line(s)**: 22-22
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart
class _NoDevicePageState extends State<NoDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SystemDataModel> (
      builder: (context, value, child) =>  Scaffold(
        appBar: systemAppBar(context, value.activeDevice),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
