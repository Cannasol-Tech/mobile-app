// Unit Tests for DisplayDataModel Provider
//
// Tests the display state management functionality including bottom navigation
// selection and listener notifications.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage
// Mocking: Permitted for external dependencies

import 'package:flutter_test/flutter_test.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  // Register fallback values for Mocktail
  setUpAll(() {
    registerMockFallbacks();
  });

  group('DisplayDataModel Tests', () {
    late DisplayDataModel displayDataModel;

    setUp(() {
      displayDataModel = DisplayDataModel();
    });

    tearDown(() {
      displayDataModel.dispose();
    });

    test('should initialize with default values', () {
      expect(displayDataModel.bottomNavSelectedItem, equals(0));
    });

    test('should set bottom navigation selected item', () {
      displayDataModel.setBottomNavSelectedItem(1);
      expect(displayDataModel.bottomNavSelectedItem, equals(1));
      
      displayDataModel.setBottomNavSelectedItem(2);
      expect(displayDataModel.bottomNavSelectedItem, equals(2));
      
      displayDataModel.setBottomNavSelectedItem(3);
      expect(displayDataModel.bottomNavSelectedItem, equals(3));
    });

    test('should handle negative index values', () {
      displayDataModel.setBottomNavSelectedItem(-1);
      expect(displayDataModel.bottomNavSelectedItem, equals(-1));
    });

    test('should handle large index values', () {
      displayDataModel.setBottomNavSelectedItem(999);
      expect(displayDataModel.bottomNavSelectedItem, equals(999));
    });

    test('should notify listeners when bottom nav item changes', () {
      bool notified = false;
      displayDataModel.addListener(() {
        notified = true;
      });

      displayDataModel.setBottomNavSelectedItem(1);
      expect(notified, isTrue);
    });

    test('should notify listeners on each change', () {
      int notificationCount = 0;
      displayDataModel.addListener(() {
        notificationCount++;
      });

      displayDataModel.setBottomNavSelectedItem(1);
      displayDataModel.setBottomNavSelectedItem(2);
      displayDataModel.setBottomNavSelectedItem(3);
      
      expect(notificationCount, equals(3));
    });

    test('should notify listeners even when setting same value', () {
      int notificationCount = 0;
      displayDataModel.addListener(() {
        notificationCount++;
      });

      displayDataModel.setBottomNavSelectedItem(1);
      displayDataModel.setBottomNavSelectedItem(1);
      displayDataModel.setBottomNavSelectedItem(1);
      
      expect(notificationCount, equals(3));
    });

    test('should maintain state across multiple operations', () {
      displayDataModel.setBottomNavSelectedItem(2);
      expect(displayDataModel.bottomNavSelectedItem, equals(2));
      
      // Simulate other operations that don't change the nav item
      displayDataModel.toString(); // Just to ensure state is maintained
      
      expect(displayDataModel.bottomNavSelectedItem, equals(2));
    });

    test('should handle rapid successive changes', () {
      final List<int> receivedValues = [];
      displayDataModel.addListener(() {
        receivedValues.add(displayDataModel.bottomNavSelectedItem);
      });

      for (int i = 0; i < 10; i++) {
        displayDataModel.setBottomNavSelectedItem(i);
      }

      expect(receivedValues.length, equals(10));
      expect(receivedValues, equals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
    });

    test('should properly dispose without errors', () {
      displayDataModel.setBottomNavSelectedItem(1);
      expect(() => displayDataModel.dispose(), returnsNormally);
    });

    test('should handle listener removal correctly', () {
      int notificationCount = 0;
      void listener() {
        notificationCount++;
      }

      displayDataModel.addListener(listener);
      displayDataModel.setBottomNavSelectedItem(1);
      expect(notificationCount, equals(1));

      displayDataModel.removeListener(listener);
      displayDataModel.setBottomNavSelectedItem(2);
      expect(notificationCount, equals(1)); // Should not increment
    });

    test('should handle multiple listeners correctly', () {
      int listener1Count = 0;
      int listener2Count = 0;

      void listener1() {
        listener1Count++;
      }

      void listener2() {
        listener2Count++;
      }

      displayDataModel.addListener(listener1);
      displayDataModel.addListener(listener2);

      displayDataModel.setBottomNavSelectedItem(1);

      expect(listener1Count, equals(1));
      expect(listener2Count, equals(1));

      displayDataModel.setBottomNavSelectedItem(2);

      expect(listener1Count, equals(2));
      expect(listener2Count, equals(2));
    });

    test('should handle edge case values correctly', () {
      // Test with minimum integer value
      displayDataModel.setBottomNavSelectedItem(-2147483648);
      expect(displayDataModel.bottomNavSelectedItem, equals(-2147483648));

      // Test with maximum integer value
      displayDataModel.setBottomNavSelectedItem(2147483647);
      expect(displayDataModel.bottomNavSelectedItem, equals(2147483647));

      // Test with zero
      displayDataModel.setBottomNavSelectedItem(0);
      expect(displayDataModel.bottomNavSelectedItem, equals(0));
    });

    test('should maintain type safety', () {
      displayDataModel.setBottomNavSelectedItem(42);
      expect(displayDataModel.bottomNavSelectedItem, isA<int>());
      expect(displayDataModel.bottomNavSelectedItem, equals(42));
    });
  });
}
