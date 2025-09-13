# Cannasol Technologies Mobile App

Always follow these instructions first and fallback to search or additional context gathering only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites Installation

Install Flutter SDK and required dependencies:

```bash
# Install Flutter 3.29+ (REQUIRED)
# Download Flutter SDK 
curl -o /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.1-stable.tar.xz
cd /tmp && tar -xf flutter.tar.xz

# Add Flutter to PATH
export PATH="/tmp/flutter/bin:$PATH"

# Verify installation
flutter --version
flutter doctor

# Install additional tools if needed
# For Linux: sudo apt-get install curl git unzip xz-utils zip libglu1-mesa
# For macOS: Xcode 15.4+ required for iOS development
```

### Bootstrap and Build Process

**CRITICAL: NEVER CANCEL ANY BUILD COMMANDS - Set timeout to 60+ minutes**

```bash
# 1. Navigate to Flutter project directory
cd cannasoltech_automation

# 2. Install dependencies (takes 3-5 minutes)
flutter pub get

# 3. Clean build cache if needed
flutter clean

# 4. Build for web (takes 8-12 minutes - NEVER CANCEL)
flutter build web

# 5. Run complete test suite (takes 5-8 minutes - NEVER CANCEL)  
flutter test --coverage

# Alternative: Use Makefile commands from root directory
cd ..
make install         # Installs dependencies
make test           # Runs complete test suite (5-8 minutes)
make build          # Builds for production (8-12 minutes)
```

### Running the Application

**ALWAYS run dependency installation first before any run commands**

```bash
# Web development (primary platform)
flutter run -d chrome --hot

# Alternative using Makefile
make preview-web

# iOS simulator (requires macOS with Xcode)
flutter run -d ios --hot
make preview-ios

# Android emulator
flutter run -d android --hot  
make preview-android

# List available devices
flutter devices
make devices
```

## Testing Framework (CRITICAL STANDARDS)

### Testing Commands with Timing

**WARNING: NEVER CANCEL test commands - builds may take 5-8 minutes**

```bash
# Complete test suite (5-8 minutes - NEVER CANCEL, timeout 15+ minutes)
flutter test --coverage
make test

# Unit tests only (≥85% coverage required, mocking allowed via Mocktail)
flutter test test/unit/ --coverage
make test-unit

# Widget tests only (≥85% coverage required, dependency mocking allowed via Mocktail; do not mock widgets/rendering)
flutter test test/widget/ --coverage  
make test-widget

# Integration tests (critical paths, no mocking)
flutter test integration_test/
make test-integration

# Golden tests (visual regression, no mocking)
flutter test --dart-define=ENABLE_GOLDEN_TESTS=true test/widget/
make test-golden

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Testing Framework Standards (MANDATORY)

**Mocking Framework**: Mocktail ^1.0.4 (OFFICIAL STANDARD)
- ✅ **ALLOWED**: Mocktail for external dependencies in unit and widget tests
- ❌ **PROHIBITED**: Mockito (company-wide ban)
- ❌ **PROHIBITED**: Mocking Flutter SDK widgets or rendering pipeline
- ❌ **PROHIBITED**: Any mocking in integration or golden tests

**Coverage Requirements**:
- Unit Tests: ≥85% statement coverage (enforced)
- Widget Tests: ≥85% widget coverage (enforced)  
- Overall Project: ≥80% total coverage (enforced)

## Validation

### Manual Testing Requirements

**ALWAYS manually validate changes through complete user scenarios after making modifications:**

1. **Authentication Flow**: Test sign-in with email/password and Google Sign-In
2. **Device Monitoring**: Verify real-time data display and updates  
3. **Alarm System**: Test alarm notifications and push notification handling
4. **Cross-Platform**: Validate on web browser, and iOS/Android if available
5. **Firebase Integration**: Ensure database, auth, and storage functionality works

### Pre-Commit Validation

**ALWAYS run these commands before committing (or CI will fail):**

```bash
# Format code
dart format .

# Analyze for issues  
flutter analyze

# Run tests with coverage
flutter test --coverage

# Validate coverage meets requirements
make validate-coverage
```

## Project Navigation

### Key Directories and Files

```bash
# Flutter project root
cannasoltech_automation/

# Main application source
lib/
├── main.dart                 # Application entry point with Firebase setup
├── pages/                    # UI screens and pages
├── components/               # Reusable UI components  
├── handlers/                 # Business logic handlers
├── providers/                # State management (Provider pattern)
├── api/                      # Firebase API integration
├── objects/                  # Data models and objects
└── shared/                   # Shared utilities and constants

# Testing structure (46 test files)
test/
├── unit/                     # Business logic tests (70% of tests)
├── widget/                   # UI component tests (20% of tests)
├── integration/              # End-to-end tests (10% of tests)  
├── golden/                   # Visual regression tests
└── helpers/                  # Test utilities and mocks

# Configuration files
pubspec.yaml                  # Flutter dependencies and project config
firebase.json                 # Firebase project configuration  
analysis_options.yaml        # Dart analyzer configuration
```

### Important Configuration Files

- **pubspec.yaml**: Flutter 3.29+, Dart 3.7+, Mocktail ^1.0.4 testing framework
- **firebase.json**: Multi-platform Firebase configuration (Android, iOS, Web)
- **lib/firebase_options.dart**: Auto-generated Firebase configuration
- **test/README.md**: Comprehensive testing guidelines and examples

## Development Workflow

### Making Changes

1. **Run tests first**: `make test` to understand current state (5-8 minutes)
2. **Make minimal changes**: Follow surgical modification approach
3. **Test frequently**: Run relevant test subset after each change
4. **Validate manually**: Test actual user scenarios in running app
5. **Pre-commit checks**: Format, analyze, test before committing

### Architecture Patterns

- **State Management**: Provider pattern with ChangeNotifier
- **Authentication**: Firebase Auth with Google Sign-In integration
- **Database**: Firebase Realtime Database for real-time industrial data
- **Navigation**: MaterialApp with named routes and push notification handling
- **Testing**: Repository pattern with mocked dependencies

## Firebase Integration

### Firebase Services Used

- **Authentication**: Email/password and Google Sign-In
- **Realtime Database**: Industrial device monitoring data
- **Cloud Storage**: Media and configuration files
- **Cloud Messaging**: Push notifications for alarm alerts
- **Hosting**: Web deployment platform

### Firebase Setup Validation

```bash
# Verify Firebase configuration
cat cannasoltech_automation/firebase.json
cat cannasoltech_automation/lib/firebase_options.dart

# Test Firebase emulator (for integration testing)
firebase emulators:start --only auth,database,storage
```

## Common Commands Quick Reference

| Task | Command | Time | Timeout |
|------|---------|------|---------|
| Install deps | `make install` | 3-5 min | 10 min |
| Run tests | `make test` | 5-8 min | 15 min |
| Build app | `make build` | 8-12 min | 20 min |
| Run web | `make preview-web` | 1-2 min | 5 min |
| Format code | `dart format .` | 30 sec | 2 min |
| Analyze code | `flutter analyze` | 1-2 min | 5 min |

## Troubleshooting

### Common Issues

**Build failures**: Run `flutter clean && flutter pub get` then retry
**Test failures**: Check Mocktail usage, ensure no Mockito imports
**Firebase errors**: Verify firebase.json and firebase_options.dart configuration  
**Coverage failures**: Ensure ≥85% unit/widget and ≥80% overall coverage
**Web deployment issues**: Verify Flutter web build completes successfully

### Required Tools

- Flutter 3.29+ (CRITICAL)
- Dart 3.7+ (included with Flutter)
- Chrome browser (for web development and testing)
- Firebase CLI (for emulator testing): `npm install -g firebase-tools`
- lcov (for coverage HTML reports): `brew install lcov` or `apt-get install lcov`

---

**CRITICAL REMINDERS**:
- NEVER CANCEL builds or tests - they may take 5-12 minutes
- Use Mocktail ONLY (Mockito prohibited)
- Maintain ≥85% test coverage
- Always validate changes through complete user scenarios
- Set timeouts to 15+ minutes for builds and 10+ minutes for tests