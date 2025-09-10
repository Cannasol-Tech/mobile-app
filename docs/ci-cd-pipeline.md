# CI/CD Pipeline Documentation

This document describes the CI/CD pipeline implementation for the Cannasol Technologies Mobile Application, following company standards from `.axovia-flow/company-standards/`.

## Overview

The CI pipeline implements comprehensive PR gating and release automation following these company standards:
- **Makefile Standard**: Uses standardized make targets
- **Testing Standard**: Flutter-specific testing with proper coverage requirements
- **Release Format**: Generates standardized test artifacts
- **Pull Request Standard**: Implements proper PR gating and quality checks

## Workflows

### 1. PR Gating CI Pipeline (`.github/workflows/pr-gating.yml`)

**Triggers:**
- Pull requests to `main` or `develop` branches
- Pushes to `main` branch
- Tag pushes (`v*`)
- Manual workflow dispatch

**Quality Gates:**
- ✅ Flutter environment setup and verification
- ✅ Code analysis (`flutter analyze`)
- ✅ Complete test suite execution (`make test`)
- ✅ Test report generation in company-standard format
- ✅ Coverage validation against thresholds
- ✅ Artifact upload and release publishing

**Artifacts Generated:**
- `final/executive-report.json` (required)
- `final/coverage-summary.json` (optional)
- `final/unit-test-summary.json` (optional)

### 2. Dependency Updates (`.github/workflows/dependency-updates.yml`)

**Triggers:**
- Weekly schedule (Mondays at 9 AM UTC)
- Manual workflow dispatch

**Actions:**
- Updates Flutter dependencies
- Runs test suite for compatibility validation
- Creates automated pull requests for review

## Make Targets

Following company standards, the pipeline uses these standardized make targets:

```bash
make install         # Install dependencies
make test           # Complete test suite
make test-unit      # Unit tests (≥85% coverage)
make test-widget    # Widget tests (≥70% coverage)
make test-integration # Integration tests
make test-golden    # Golden tests (visual regression)
```

## Coverage Requirements

| Test Type | Minimum Coverage | Enforcement |
|-----------|------------------|-------------|
| Unit Tests | 85% | CI Pipeline |
| Widget Tests | 70% | CI Pipeline |
| Overall Project | 80% | CI Pipeline |

## Test Report Format

### Executive Report (`final/executive-report.json`)
```json
{
  "version": "1.0.0",
  "owner": "Cannasol-Tech",
  "repo": "mobile-app",
  "releaseTag": "v1.2.3",
  "commit": "abc1234",
  "createdAt": "2025-08-14T22:30:00Z",
  "summary": {
    "total": 120,
    "passed": 118,
    "failed": 2,
    "skipped": 0,
    "durationMs": 321000
  },
  "scenarios": [...],
  "requirements": [...]
}
```

### Coverage Summary (`final/coverage-summary.json`)
```json
{
  "version": "1.0.0",
  "owner": "Cannasol-Tech",
  "repo": "mobile-app",
  "totals": {
    "lines": {"pct": 84.2, "covered": 842, "total": 1000},
    "statements": {"pct": 83.1, "covered": 831, "total": 1000},
    "functions": {"pct": 80.0, "covered": 80, "total": 100},
    "branches": {"pct": 75.5, "covered": 151, "total": 200}
  },
  "files": [...]
}
```

## PR Template

The repository includes a standardized PR template (`.github/pull_request_template.md`) that follows company standards and includes:
- Description and related issues
- Type of change classification
- Testing information
- Quality gates checklist
- Automated CI status integration

## Scripts

### Report Generation Scripts (`scripts/`)

1. **`generate_executive_report.py`**
   - Converts test results to standardized executive report format
   - Maps scenarios to requirements (PRD compliance)
   - Includes evidence URLs for CI runs

2. **`generate_coverage_summary.py`**
   - Parses LCOV coverage data
   - Generates company-standard coverage summary
   - Supports per-file coverage details

3. **`generate_unit_test_summary.py`**
   - Extracts unit test results
   - Summarizes test suites and failures
   - Provides duration metrics

4. **`validate_coverage.py`**
   - Validates coverage against company thresholds
   - Provides clear feedback on compliance
   - Supports graceful degradation during development

## Quality Gates

### Automated Checks
- ✅ Code analysis with `flutter analyze`
- ✅ Complete test suite execution
- ✅ Coverage threshold validation
- ✅ Artifact generation compliance
- ✅ PR commenting with results

### Manual Review Points
- Integration test critical path coverage
- Architecture changes approval
- Breaking change impact assessment

## Usage

### For Developers

1. **Creating PRs**: Use the provided PR template and ensure all quality gates pass
2. **Local Testing**: Run `make test` before pushing to verify changes
3. **Coverage**: Maintain ≥85% unit test coverage for new code

### For CI/CD

1. **Automatic**: Pipeline runs on all PRs and main branch pushes
2. **Manual**: Use workflow dispatch for ad-hoc testing
3. **Release**: Tag with `v*` pattern to trigger release workflow

## Troubleshooting

### Common Issues

1. **Flutter Not Found**: CI uses Flutter 3.29.0 stable channel
2. **Test Failures**: Check individual make targets (`make test-unit`, etc.)
3. **Coverage Issues**: Review coverage reports in CI artifacts
4. **Artifact Missing**: Ensure scripts run successfully in CI

### Getting Help

- Review company standards in `.axovia-flow/company-standards/`
- Check workflow logs in GitHub Actions
- Validate local setup with `make test`

## Future Enhancements

- Integration with functionality reports dashboard
- Enhanced BDD scenario parsing
- Cross-platform testing matrix
- Performance benchmarking integration