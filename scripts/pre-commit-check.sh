#!/bin/bash

# Pre-commit script to run the same checks as CI
# Run this from the repository root directory

set -e

echo "🏗️  Setting up Flutter environment..."
cd cannasoltech_automation

echo "📦 Getting dependencies..."
flutter pub get

echo "📋 Checking dependencies..."
flutter pub deps

echo "🎨 Checking code formatting..."
dart format --output=none --set-exit-if-changed .

echo "🔍 Running static analysis..."
flutter analyze --fatal-infos

echo "🧪 Running unit tests..."
flutter test --coverage --reporter=expanded

echo "✅ All checks passed! Ready to create a pull request."