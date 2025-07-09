# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/side_menu.dart`
- **Line(s)**: 128-128
- **Method/Widget**: `Text`

## Description


## Why This Matters


## Current Code
```dart
                  ListTile(
                    leading: const Icon(Icons.app_registration),
                    title: const Text('Register a device', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    onTap: () {
                      Provider.of<DisplayDataModel>(context, listen: false).setBottomNavSelectedItem(-1);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegisterDevicePage(title: "Register a Device")));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
