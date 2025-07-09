# cannasoltech_automation

Automation System control for Cannasol Technologies - A Flutter mobile application.

## Getting Started

This project is a Flutter application for controlling and monitoring Cannasol Technologies' automation systems.

## CI Pipeline

This project includes an automated CI pipeline using GitHub Actions that runs tests on every pull request to ensure code quality.

### Features

- **Automated Testing**: Runs all Flutter unit tests on pull requests
- **Code Analysis**: Performs static code analysis with `flutter analyze`
- **Cross-Platform**: Tests run on Ubuntu (Linux) environment
- **Coverage Reports**: Generates and uploads test coverage data
- **PR Integration**: Shows test status directly on pull requests
- **Manual Triggers**: Can be run manually via GitHub Actions UI

### Workflow Triggers

The CI pipeline automatically runs when:
- A pull request is created or updated targeting `main` or `develop` branches
- Manually triggered via the GitHub Actions "workflow_dispatch" option

### Test Results

- ✅ **Green checkmark**: All tests passed - PR is ready for review
- ❌ **Red X**: Tests failed - review the error details and fix issues before merging
- 📊 **Test artifacts**: Coverage reports and detailed results are available in the Actions tab

### Running Tests Locally

```bash
# Install dependencies
flutter pub get

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

### Adding New Tests

Tests are located in the `test/` directory:
- `test/widget_test.dart` - Main application widget tests
- `test/components/` - Component-specific tests

Follow the existing test patterns and ensure all new features include appropriate test coverage.

## Development

### Prerequisites

- Flutter SDK 3.24.3 or later
- Dart SDK (included with Flutter)

### Project Structure

- `lib/` - Main application source code
- `test/` - Test files
- `assets/` - Images, documents, and other assets
- `.github/workflows/` - CI/CD pipeline configuration

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
