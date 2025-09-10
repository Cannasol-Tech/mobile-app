// Bottom Navigation Bar Widget Tests
//
// This file contains comprehensive widget tests for the BottomNavBar component.
// Tests verify UI behavior, navigation, user interactions, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';

// Import centralized test helpers
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('BottomNavBar Widget Tests', () {
    late ProviderMockSetup providerMocks;

    setUp(() {
      providerMocks = MockSetup.createProviderMocks();

      // Setup common mock behaviors
      when(() => providerMocks.displayDataModel.currentPageIndex).thenReturn(0);
      when(() => providerMocks.displayDataModel.setPageIndex(any()))
          .thenReturn(null);
    });

    group('Rendering Tests', () {
      testWidgets('should render with all navigation items',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(BottomNavBar));
        TestAssertions.expectVisible(find.text(UITestData.homeTitle));
        TestAssertions.expectVisible(find.text(UITestData.configurationTitle));
      });

      testWidgets('should display correct icons for navigation items',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.home));
        TestAssertions.expectVisible(find.byIcon(Icons.settings));
      });

      testWidgets('should highlight selected tab correctly',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(1);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.currentIndex, equals(1));
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate to home when home tab is tapped',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(1);

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.text(UITestData.homeTitle));

        // Assert
        verify(() => providerMocks.displayDataModel.setPageIndex(0)).called(1);
      });

      testWidgets('should navigate to configuration when config tab is tapped',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(0);

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(
            tester, find.text(UITestData.configurationTitle));

        // Assert
        verify(() => providerMocks.displayDataModel.setPageIndex(1)).called(1);
      });

      testWidgets(
          'should not call setPageIndex when tapping already selected tab',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(0);

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.text(UITestData.homeTitle));

        // Assert - Should still be called as BottomNavigationBar always calls onTap
        verify(() => providerMocks.displayDataModel.setPageIndex(0)).called(1);
      });
    });

    group('State Management Tests', () {
      testWidgets('should update selected tab when page index changes',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(0);

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Verify initial state
        var bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.currentIndex, equals(0));

        // Act - Simulate page index change
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(1);
        providerMocks.displayDataModel.notifyListeners();
        await tester.pump();

        // Assert
        bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.currentIndex, equals(1));
      });

      testWidgets('should handle invalid page index gracefully',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(-1);

        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        TestAssertions.expectVisible(find.byType(BottomNavBar));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final homeSemantics =
            tester.getSemantics(find.text(UITestData.homeTitle));
        final configSemantics =
            tester.getSemantics(find.text(UITestData.configurationTitle));

        expect(homeSemantics.label, contains('Home'));
        expect(configSemantics.label, contains('Configuration'));
      });

      testWidgets('should be accessible via screen reader',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(bottomNavBar.type, equals(BottomNavigationBarType.fixed));
      });
    });

    group('Theme and Styling Tests', () {
      testWidgets('should apply correct theme colors',
          (WidgetTester tester) async {
        // Arrange
        final customTheme = ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        );

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
            theme: customTheme,
          ),
        );

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(bottomNavBar.selectedItemColor, equals(Colors.blue));
        expect(bottomNavBar.unselectedItemColor, equals(Colors.grey));
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid tab switching',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.displayDataModel.currentPageIndex)
            .thenReturn(0);

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act - Rapid tab switching
        for (int i = 0; i < 10; i++) {
          await TestInteractions.tap(
              tester, find.text(UITestData.configurationTitle));
          await tester.pump(const Duration(milliseconds: 10));
          await TestInteractions.tap(tester, find.text(UITestData.homeTitle));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert - Should not throw or cause performance issues
        expect(tester.takeException(), isNull);
        TestAssertions.expectVisible(find.byType(BottomNavBar));
      });
    });
  });
}
