// Unit Tests for Shared Methods
//
// This file contains unit tests for the utility functions in `shared/methods.dart`.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥95% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:cannasoltech_automation/shared/methods.dart';

void main() {
  group('Shared Methods Tests', () {
    group('displayDouble', () {
      test('should format double with specified decimal places', () {
        expect(displayDouble(10.12345, 2), '10.12');
      });

      test('should append units when provided', () {
        expect(displayDouble(25.5, 1, units: '°C'), '25.5°C');
      });

      test('should handle zero decimal places', () {
        expect(displayDouble(15.7, 0), '16');
      });
    });

    group('padZeros', () {
      test('should pad number with leading zeros', () {
        expect(padZeros(5, 2), '05');
      });

      test('should not pad if number already meets length', () {
        expect(padZeros(15, 2), '15');
      });
    });

    group('StringExtension', () {
      test('toCapital should capitalize the first letter', () {
        expect('hello'.toCapital(), 'Hello');
      });

      test('toCapital should handle empty string', () {
        expect(''.toCapital(), '');
      });
    });

    group('StringExtensions', () {
      test('toTitleCase should capitalize each word', () {
        expect('hello world'.toTitleCase(), 'Hello World');
      });
    });
  });
}
