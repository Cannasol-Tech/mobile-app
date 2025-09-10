# Auggie Instructions for Cannasol Technologies Mobile Application

## Purpose

Ensure Auggie (Augment Agent) consistently follows our house rules and repository standards for the Cannasol Technologies Mobile Application project.

## Project Type

The Mobile Application is a Flutter Cross Platform Application that utilizes Google Cloud Platform to monitor and control Cannasol Technologies' Industrial Automation System used for Ultrasonic Liquid Processing.

- NOTE: Since this is a Cross Platform Flutter Application, make sure to follow the flutter specific Company Standards as well as the company's general project standard operating procedures.  The Flutter Specific Company Standards are located in the `docs/standards/flutter-specific/` directory.

## Source of Truth Hierarchy

1. **Primary standards**: `docs/standards/` (single source of truth)
2. **Architecture docs**: `docs/architecture/` and PRD documents
3. **Legacy standards**: `.bmad-core/*` (only when not in conflict)

> **Note**: If standards are duplicated elsewhere, treat `docs/standards/` as canonical. Flag any divergence and propose sync PRs.

## Decision Hierarchy (highest to lowest priority)

1. This instructions file (`auggie.md`)
2. `docs/standards/*` adhere closely to the company-wide standards outlined in these Standard Operating Procedure documents.  These documents are the single source of truth for company-wide standards.  We should always stay up-to-date with the latest standards by running the make target `make update-standards`.
3. `docs/architecture/*` adhere closely to the architecture outlined in these sharded documents.
4. `docs/prd/*` adhere closely to the Project Requirements outlined in the sharded PRD documents here.

TODO:  Add the following directories to the project to complete the AI Decision Hierarchy.
<!-- 3. `docs/architecture/*` and PRD docs
4. `.bmad-core/*` (only when not conflicting) --> -->

## Coding & Architecture Standards

### Code Quality

- **Modular Design**: Write modular, object-oriented code with single responsibility per class/function
- **DRY Principle**: Avoid duplication; centralize shared logic in reusable modules/services
- **Single Source of Truth**: Maintain one authoritative source for configuration, constants, and policies
- **Documentation**: Use doxygen-style comments for public interfaces and important modules
- **Architecture Changes**: Before making architecture-level changes (new modules/services, cross-cutting patterns), pause and request user approval with a brief plan/diagram

### Code Structure

```markdown
- One clear, distinct purpose per function
- Centralized services/modules for shared functionality
- Clean architecture with easily accessible components
- Reusable functions and classes
```

## Testing & Quality Assurance

### Definition of Done

- Unit Tests must be completed for all newly implemented features
- Unit Test Coverage must exceed 85% statement coverage
- Unit Test Coverage must be neatly displayed in the test report after running make test-unit
- The test report must follow the standards listed in `docs/standards/sw-testing-standard.md` and `docs/standards/release-report.md`
- The feature must be verified through Acceptance BDD Tests with scenarios that are neatly mapped to PRD Requirements.
- The Acceptance BDD Tests must be run through the make target: make test-acceptance
- The Acceptance BDD Test Report must follow the standards listed in `docs/standards/sw-testing-standard.md` and `docs/standards/release-report.md
- The new functionality must be triple-checked for any code duplication or integration issues with existing systems.
- Regression: All previously written tests should pass after the new functionality is implemented.
- Previously written tests that are failing after the new feature has been implemented should be elevated to Project Management's attention by creating a file in the repository called `REGRESSION-ISSUES.md` which should clearly outline which tests are now failing and why they are failing.  The file should also outline potential solutions to fix the issues with pro's and cons for each solution clearly listed.

### Testing Standards

- **Organization Standard**: Follow `docs/standards/flutter-testing-standard.md` (official company policy)
- **Project Implementation**: See project-specific details in "Mobile Application Testing Framework Requirements" section below
- All tests should be run solely by make targets as defined in the Company's Software Testing Standards
- Follow testing guidance in `docs/standards/sw-testing-standard.md` and `docs/standards/flutter-testing-standard.md`
- Enforce coverage thresholds as defined in canonical standards
- For conflicts between testing standards, prefer `docs/standards/` and report deltas
- **Verification Requirement**: For every code change, add/update tests until behavior is verified
- Prefer fast, deterministic tests
- Provide test plans and execution commands
- **Critical Rule**: MOCKING IS ONLY TO BE USED FOR UNIT TESTING (never in widget, integration, or golden tests)

### Quality Gates

- All code must be tested before delivery
- Never deliver untested functionality
- Always verify added code works through comprehensive testing
- Unit Test Coverage must exceed 85% for all newly implemented features

## Tooling & Safety

- Always use your task manager for all tasks - even when a single task is only required, use the task manager.
- When working, create a task list using your task manager for all tasks to be completed at all times.
- Be consistent with updating your task list using your task manager tool.
- The task manager should be utilized and kept up to date whether working on a single test or a large feature with many tasks.  Using the task manager helps increase visibility for project management and alignment between Agents and Project Managers.

### Dependency Management

- **Use Package Managers**: npm/yarn/pnpm, pip/poetry, cargo, go mod, etc.
- **Never Hand-Edit**: Do not manually edit lockfiles or package configuration files
- Let package managers handle version resolution and dependency conflicts

### Safety Practices

- Show diffs before writing files
- Ask permission before executing commands or modifying files
- Prefer the smallest, safest change that satisfies requirements
- Use appropriate tools for external resource access
- Use GitHub tool for all GitHub interactions

## Documentation & Process

### Documentation Updates

- Update implementation-plan documents when tasks complete
- Keep README/Usage examples current when CLI or developer UX changes
- Maintain doxygen comments for documentation generation

### Communication

- **Ask Questions**: Never hesitate to ask for clarification
- Ensure alignment on project vision and approach
- **Suggest Improvements**: Propose better solutions when identified
- **Include URLs**: When requesting items from humans, include step-by-step instruction URLs

## Decision Making

### When Unsure

- Ask for clarification with 1-3 options and a recommendation
- Ensure we're on the same page before proceeding
- Get architecture decisions approved before implementation

### Improvement Mindset

- Suggest more efficient, cheaper, or better solutions
- Engage in conversations about approaches
- Challenge approaches constructively when beneficial

## Project-Specific Guidelines -- Cannasol Technologies Mobile Application

### Cannasol Techonlogies Mobile Application Overview

- The Mobile Application is a Flutter Cross Platform Application, this means we should follow the `docs/standards/flutter-testing-standard.md` for testing standards.
- The Mobile Application project should be well documented.
- The Mobile Application project runs as a Google Cloud Project.
- The Application should support Android, IOS, and Web Platforms.
- The Application should utilize dynamic screen layouts to support many different screen sizes.
- The Application should be beatuifully modern and professional in appearance.
- The Application should be sleek, functional and easy to use and understand.

### Cannasol Technologies Mobile Application Focus

- We are very far behind in regards to test coverage requirements for this project.  Our focus should be increasing unit test coverage to meet company standards.
- We also need to increase the documentation for this project.

#### Mobile Application Testing Framework Requirements

**Official Framework Stack:**

- **Primary Testing**: `flutter_test` (SDK) - Required for ALL Flutter testing
- **Mocking**: `mocktail` ^1.0.4 - **OFFICIAL STANDARD** (Unit tests ONLY)
- **BLoC Testing**: `bloc_test` ^9.1.7 - Required when using BLoC pattern
- **Integration Testing**: `integration_test` (SDK) - Required for E2E testing
- **Code Quality**: `flutter_lints` ^5.0.0 - Required

**Prohibited Frameworks:**

- ❌ **Mockito**: Deprecated in favor of Mocktail
- ❌ **Any other mocking libraries**: Use Mocktail exclusively

**Test Organization Structure:**

```markdown
test/
├── unit/                    # Business logic tests (70% of tests)
│   ├── models/             # Data model tests
│   ├── services/           # Service layer tests
│   ├── handlers/           # Handler class tests
│   └── utils/              # Utility function tests
├── widget/                 # UI component tests (20% of tests)
│   ├── pages/              # Page widget tests
│   ├── components/         # Reusable component tests
│   └── dialogs/            # Dialog widget tests
├── integration/            # End-to-end tests (10% of tests)
│   ├── flows/              # User journey tests
│   └── platform/           # Platform-specific tests
├── golden/                 # Visual regression tests
│   └── screenshots/        # Golden file storage
└── helpers/                # Test utilities and helpers
    ├── mocks.dart          # Centralized mock definitions
    ├── test_data.dart      # Test data constants
    └── test_utils.dart     # Common test utilities
```

**Coverage Requirements:**

- **Unit Tests**: ≥85% statement coverage (CI/CD enforced)
- **Widget Tests**: ≥85% widget coverage (CI/CD enforced)
- **Integration Tests**: Critical paths coverage (Manual review)
- **Overall Project**: ≥85% coverage (CI/CD enforced)

**Mocking Rules (CRITICAL):**

- **MOCKING IS ONLY TO BE USED FOR UNIT TESTING**
- ❌ NO mocking in widget tests (defeats purpose of UI testing)
- ❌ NO mocking in integration tests (defeats purpose of E2E testing)
- ❌ NO mocking in golden tests (defeats purpose of visual testing)
- ✅ Mock external dependencies in unit tests only

**Make Targets (Required):**

```bash
# Unit Testing (mocking allowed)
make test-unit
# - Executes: flutter test test/unit/
# - Coverage: ≥85% requirement
# - Mocking: Mocktail permitted

# Widget Testing (NO mocking)
make test-widget
# - Executes: flutter test test/widget/
# - Coverage: ≥85% requirement
# - Mocking: PROHIBITED

# Golden Testing (visual regression)
make test-golden
# - Executes: flutter test test/golden/
# - Mocking: PROHIBITED

# Integration Testing (end-to-end)
make test-integration
# - Executes: flutter test integration_test/
# - Mocking: PROHIBITED

# Complete Test Suite
make test
# - Executes all test types in sequence
```

**Mocktail Best Practices:**

```dart
// ✅ Correct: Mock interfaces for unit tests
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockAuthCredential extends Fake implements AuthCredential {}

// Fallback value registration
void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });
}

// Proper stubbing
when(() => mockAuth.signInWithCredential(any()))
    .thenAnswer((_) async => mockUserCredential);

// Verification
verify(() => mockAuth.signInWithCredential(any())).called(1);
```

**Project-Specific Examples:**

```dart
// Unit test example (cannasoltech_automation specific)
import 'package:cannasoltech_automation/handlers/user_handler.dart';

// Widget test example (cannasoltech_automation specific)
import 'package:cannasoltech_automation/components/square_tile.dart';
```

## Metadata

- **File**: `.auggie.md` (repository root)
- **Created**: 2025-01-05
- **Last Updated**: 2025-01-05
- **Project**: Cannasol Technologies Mobile Application
- **Repository**: cannasol-technologies/mobile-app
- **Framework**: Flutter 3.29+, Dart 3.7+
- **Testing Standard**: Mocktail (Official)

---

*This file serves as the primary instruction set for Auggie when working on the Cannasol Technologies Mobile Application project. All development work should align with these guidelines and the organization-wide Flutter testing standard.*
