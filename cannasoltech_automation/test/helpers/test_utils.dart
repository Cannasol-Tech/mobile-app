// Test Utilities
//
// This file contains common utility functions and helpers used throughout
// the test suite to reduce code duplication and improve test maintainability.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow TESTING-STANDARDS.md guidelines

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/shared/maps.dart';

import 'mocks.dart';
import 'test_data.dart';

// =============================================================================
// Widget Test Utilities
// =============================================================================

/// Creates a MaterialApp wrapper for widget testing
/// 
/// Usage:
/// ```dart
/// await tester.pumpWidget(createTestApp(child: MyWidget()));
/// ```
Widget createTestApp({
  required Widget child,
  ThemeData? theme,
  Locale? locale,
}) {
  return MaterialApp(
    title: UITestData.appTitle,
    theme: theme ?? ThemeData.light(),
    locale: locale,
    home: child,
  );
}

/// Creates a MaterialApp with Provider setup for testing widgets that need providers
/// 
/// Usage:
/// ```dart
/// await tester.pumpWidget(createTestAppWithProviders(
///   child: MyWidget(),
///   systemDataModel: mockSystemDataModel,
/// ));
/// ```
Widget createTestAppWithProviders({
  required Widget child,
  SystemDataModel? systemDataModel,
  DisplayDataModel? displayDataModel,
  TransformModel? transformModel,
  SystemIdx? systemIdx,
  ThemeData? theme,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<SystemIdx>.value(
        value: systemIdx ?? MockSystemIdx(),
      ),
      ChangeNotifierProvider<SystemDataModel>.value(
        value: systemDataModel ?? MockSystemDataModel(),
      ),
      ChangeNotifierProvider<TransformModel>.value(
        value: transformModel ?? MockTransformModel(),
      ),
      ChangeNotifierProvider<DisplayDataModel>.value(
        value: displayDataModel ?? MockDisplayDataModel(),
      ),
    ],
    child: MaterialApp(
      title: UITestData.appTitle,
      theme: theme ?? ThemeData.light(),
      home: child,
    ),
  );
}

/// Pumps a widget and waits for all animations and async operations to complete
///
/// Usage:
/// ```dart
/// await pumpAndSettleWidget(tester, MyWidget());
/// ```
Future<void> pumpAndSettleWidget(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  if (duration != null) {
    await tester.pumpAndSettle(duration);
  } else {
    await tester.pumpAndSettle();
  }
}

// =============================================================================
// Finder Utilities
// =============================================================================

/// Common finders for UI elements
class TestFinders {
  // Authentication UI elements
  static Finder get emailField => find.byKey(const Key('email_field'));
  static Finder get passwordField => find.byKey(const Key('password_field'));
  static Finder get signInButton => find.text(UITestData.signInButton);
  static Finder get signUpButton => find.text(UITestData.signUpButton);
  static Finder get googleSignInButton => find.text(UITestData.googleSignInButton);
  static Finder get forgotPasswordButton => find.text(UITestData.forgotPasswordButton);
  
  // Navigation elements
  static Finder get homeTab => find.text(UITestData.homeTitle);
  static Finder get configurationTab => find.text(UITestData.configurationTitle);
  
  // Common UI elements
  static Finder get loadingIndicator => find.byType(CircularProgressIndicator);
  static Finder get backButton => find.byType(BackButton);
  static Finder get appBar => find.byType(AppBar);
  
  // Error and success messages
  static Finder errorMessage(String message) => find.text(message);
  static Finder successMessage(String message) => find.text(message);
}

// =============================================================================
// Interaction Utilities
// =============================================================================

/// Common UI interactions
class TestInteractions {
  /// Enters text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }
  
  /// Taps a widget and waits for the tap to complete
  static Future<void> tap(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pump();
  }
  
  /// Scrolls to make a widget visible and then taps it
  static Future<void> scrollAndTap(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.scrollUntilVisible(finder, 100);
    await tester.tap(finder);
    await tester.pump();
  }
  
  /// Performs a sign-in flow with given credentials
  static Future<void> performSignIn(
    WidgetTester tester, {
    String email = AuthTestData.validEmail,
    String password = AuthTestData.validPassword,
  }) async {
    await enterText(tester, TestFinders.emailField, email);
    await enterText(tester, TestFinders.passwordField, password);
    await tap(tester, TestFinders.signInButton);
    await tester.pumpAndSettle();
  }
}

// =============================================================================
// Assertion Utilities
// =============================================================================

/// Common assertions for testing
class TestAssertions {
  /// Verifies that a widget is visible on screen
  static void expectVisible(Finder finder) {
    expect(finder, findsOneWidget);
  }
  
  /// Verifies that a widget is not visible on screen
  static void expectNotVisible(Finder finder) {
    expect(finder, findsNothing);
  }
  
  /// Verifies that multiple widgets are visible
  static void expectMultiple(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }
  
  /// Verifies that an error message is displayed
  static void expectErrorMessage(String message) {
    expectVisible(TestFinders.errorMessage(message));
  }
  
  /// Verifies that a success message is displayed
  static void expectSuccessMessage(String message) {
    expectVisible(TestFinders.successMessage(message));
  }
  
  /// Verifies that loading indicator is shown
  static void expectLoading() {
    expectVisible(TestFinders.loadingIndicator);
  }
  
  /// Verifies that loading indicator is not shown
  static void expectNotLoading() {
    expectNotVisible(TestFinders.loadingIndicator);
  }
}

// =============================================================================
// Mock Setup Utilities
// =============================================================================

/// Utilities for setting up mocks consistently
class MockSetup {
  /// Sets up all required fallback values for Mocktail
  static void setupFallbacks() {
    registerMockFallbacks();
  }
  
  /// Creates a complete mock setup for authentication tests
  static AuthMockSetup createAuthMocks({
    bool signInSuccess = true,
    bool googleSignInSuccess = true,
  }) {
    final firebaseAuth = createMockFirebaseAuth(signInSuccess: signInSuccess);
    final googleSignIn = createMockGoogleSignIn(
      signInSuccess: googleSignInSuccess,
      account: googleSignInSuccess ? createMockGoogleAccount() : null,
    );
    final userHandler = createMockUserHandler();
    
    return AuthMockSetup(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
      userHandler: userHandler,
    );
  }
  
  /// Creates mock providers for widget tests
  static ProviderMockSetup createProviderMocks() {
    final systemDataModel = MockSystemDataModel();
    final displayDataModel = MockDisplayDataModel();
    final transformModel = MockTransformModel();
    final systemIdx = MockSystemIdx();

    // Setup basic stubs with proper return types
    when(() => systemDataModel.init()).thenAnswer((_) async {});
    when(() => transformModel.init()).thenAnswer((_) async {});
    when(() => systemIdx.init()).thenAnswer((_) async {});

    // Setup common properties that might be accessed
    when(() => systemDataModel.needsAcceptTaC).thenReturn(false);

    return ProviderMockSetup(
      systemDataModel: systemDataModel,
      displayDataModel: displayDataModel,
      transformModel: transformModel,
      systemIdx: systemIdx,
    );
  }
}

// =============================================================================
// Mock Setup Data Classes
// =============================================================================

/// Container for authentication-related mocks
class AuthMockSetup {
  final MockFirebaseAuth firebaseAuth;
  final MockGoogleSignIn googleSignIn;
  final MockUserHandler userHandler;
  
  const AuthMockSetup({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.userHandler,
  });
}

/// Container for provider-related mocks
class ProviderMockSetup {
  final MockSystemDataModel systemDataModel;
  final MockDisplayDataModel displayDataModel;
  final MockTransformModel transformModel;
  final MockSystemIdx systemIdx;
  
  const ProviderMockSetup({
    required this.systemDataModel,
    required this.displayDataModel,
    required this.transformModel,
    required this.systemIdx,
  });
}

// =============================================================================
// Test Environment Utilities
// =============================================================================

/// Utilities for managing test environment
class TestEnvironment {
  /// Sets up the test environment for a group of tests
  static void setupGroup() {
    setUpAll(() {
      MockSetup.setupFallbacks();
    });
  }
  
  /// Cleans up after each test
  static void tearDownEach() {
    tearDown(() {
      // Reset any global state if needed
    });
  }
  
  /// Checks if running in CI environment
  static bool get isCI {
    return const bool.fromEnvironment('CI', defaultValue: false);
  }
  
  /// Skips test if running in CI (for tests that require specific setup)
  static void skipInCI(String reason) {
    if (isCI) {
      // Note: skip() function needs to be imported from flutter_test
      throw UnimplementedError('Skipped in CI: $reason');
    }
  }
}

// =============================================================================
// Golden Test Utilities
// =============================================================================

/// Utilities for golden tests (visual regression testing)
class GoldenTestUtils {
  /// Performs a golden test for a widget
  static Future<void> expectGolden(
    WidgetTester tester,
    Widget widget,
    String goldenFile, {
    Size? size,
  }) async {
    if (size != null) {
      await tester.binding.setSurfaceSize(size);
    }
    
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    
    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('golden/$goldenFile'),
    );
  }
  
  /// Common screen sizes for golden tests
  static const Size phoneSize = Size(375, 667);
  static const Size tabletSize = Size(768, 1024);
  static const Size desktopSize = Size(1920, 1080);
}
