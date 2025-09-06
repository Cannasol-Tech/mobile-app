# Cannasoltech Automation Mobile App

A cross-platform Flutter application for automation system control at Cannasol Technologies.

## 🚀 Quick Start

### Prerequisites
- Flutter 3.29+
- Dart 3.7+
- iOS development: Xcode 15.4+
- Android development: Android Studio
- Web development: Chrome browser

### Installation

```bash
# Clone the repository
git clone https://github.com/Cannasol-Tech/mobile-app.git
cd mobile-app/cannasoltech_automation

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.29+
- **State Management**: Provider pattern
- **Authentication**: Firebase Auth + Google Sign-In
- **Database**: Firebase Realtime Database
- **Storage**: Firebase Storage
- **Messaging**: Firebase Cloud Messaging
- **Testing**: flutter_test + **Mocktail** (Official Standard)

### Project Structure
```
lib/
├── api/                    # API services and Firebase integration
├── components/             # Reusable UI components
├── handlers/               # Business logic handlers
├── objects/                # Data models and objects
├── pages/                  # Application screens/pages
├── providers/              # State management providers
├── shared/                 # Shared utilities and constants
└── UserInterface/          # UI-specific utilities

test/
├── unit/                   # Business logic tests (70%)
├── widget/                 # UI component tests (20%)
├── integration/            # End-to-end tests (10%)
├── golden/                 # Visual regression tests
└── helpers/                # Test utilities and mocks
```

## 🧪 Testing

### Testing Framework (Official Standard)

This project uses **Mocktail** as the official mocking framework. All tests must follow the established testing standards.

**Framework Stack:**
- **Primary**: `flutter_test` (Flutter's built-in testing)
- **Mocking**: `mocktail` ^1.0.4 (**OFFICIAL STANDARD**)
- **BLoC Testing**: `bloc_test` ^9.1.7 (for state management)
- **Integration**: `integration_test` (end-to-end testing)

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/handlers/user_handler_test.dart

# Run integration tests
flutter test integration_test/
```

### Coverage Requirements
- **Unit Tests**: 85% minimum coverage
- **Widget Tests**: 70% minimum coverage
- **Overall Project**: 80% minimum coverage

### Testing Documentation
- [TESTING-STANDARDS.md](../TESTING-STANDARDS.md) - Official testing standards
- [UNIT-TEST-FRAMEWORK-ANALYSIS.md](../UNIT-TEST-FRAMEWORK-ANALYSIS.md) - Framework analysis
- [test/README.md](test/README.md) - Test suite documentation

## 🔐 Authentication

### Supported Methods
- Email/Password authentication
- Google Sign-In (cross-platform)
- Firebase Authentication integration

### Configuration
- **iOS**: Configured with proper client IDs and URL schemes
- **Android**: Google Services integration
- **Web**: Firebase web configuration

## 🔧 Development

### Code Quality Standards
- **Linting**: flutter_lints ^5.0.0
- **Formatting**: dart format
- **Analysis**: flutter analyze
- **Testing**: Comprehensive test coverage required

### Pre-commit Checklist
- [ ] All tests pass: `flutter test`
- [ ] No linting errors: `flutter analyze`
- [ ] Code formatted: `dart format .`
- [ ] Coverage meets requirements

### Development Workflow
1. Create feature branch from `main`
2. Implement feature with tests (TDD recommended)
3. Ensure all quality checks pass
4. Create pull request
5. Code review and approval
6. Merge to main

## 📚 Documentation

### Key Documents
- [TESTING-STANDARDS.md](../TESTING-STANDARDS.md) - Testing framework standards
- [UNIT-TEST-FRAMEWORK-ANALYSIS.md](../UNIT-TEST-FRAMEWORK-ANALYSIS.md) - Testing analysis
- [.auggie.md](../.auggie.md) - AI assistant instructions

---

**This project follows strict testing standards with Mocktail as the official mocking framework. All contributions must align with established guidelines.**
