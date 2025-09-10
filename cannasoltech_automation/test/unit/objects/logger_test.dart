// Unit Tests for Logger
//
// This file contains unit tests for the logging setup in `objects/logger.dart`.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥95% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

import 'package:cannasoltech_automation/objects/logger.dart';

void main() {
  group('Logger', () {
    test('log instance should be a Logger', () {
      expect(log, isA<Logger>());
    });

    test('setupLogging should configure the root logger', () {
      // Act
      setupLogging();

      // Assert
      expect(Logger.root.level, Level.ALL);
      expect(Logger.root.onRecord, isNotNull);
    });
  });
}
