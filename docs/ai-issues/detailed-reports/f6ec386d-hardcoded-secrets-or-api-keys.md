# Issue: Hardcoded Secrets or API Keys

## Severity: Critical

## Category: Security

## Location
- **File(s)**: `lib/firebase_options.dart`
- **Line(s)**: 64-64
- **Method/Widget**: `Unknown`

## Description
Hardcoded secret value detected: "AIzaSyCOpC...". This is a security vulnerability.

## Why This Matters
Hardcoded secrets can be extracted from compiled apps and pose serious security risks.

## Current Code
```dart

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOpCrx581Twp6VGsseMtQbYCurCJt8Lnk',
    appId: '1:681058687134:ios:9cf9446c3da3577dc7438f',
    messagingSenderId: '681058687134',
    projectId: 'cannasoltech',
```

## Suggested Fix
Move secrets to environment variables or secure storage.

## Implementation Steps
1. Remove the hardcoded secret from source code
2. Add the secret to environment variables or .env file
3. Use flutter_dotenv or similar package to load secrets
4. Add .env files to .gitignore

## Additional Resources
- https://pub.dev/packages/flutter_dotenv
- https://flutter.dev/docs/deployment/obfuscate

## Estimated Effort
1-2 hours

## Analysis Confidence
High
