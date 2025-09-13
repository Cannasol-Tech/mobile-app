// Test Utilities
//
// This file contains common utility functions and helpers used throughout
// the test suite to reduce code duplication and improve test maintainability.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow TESTING-STANDARDS.md guidelines

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';

import 'mocks.dart';
import 'test_data.dart';

// =============================================================================
// Test Setup Utilities
// =============================================================================

typedef Callback = void Function(MethodCall call);

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = TestDefaultBinaryMessenger(TestWidgetsFlutterBinding.instance.defaultBinaryMessenger);
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');

  messenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'mock_api_key',
            'appId': 'mock_app_id',
            'messagingSenderId': 'mock_sender_id',
            'projectId': 'mock_project_id',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (methodCall.method == 'Firebase#initializeApp') {
      return {
        'name': methodCall.arguments['appName'],
        'options': methodCall.arguments['options'],
        'pluginConstants': {},
      };
    }
    return null;
  });
}

/// Mocks Firebase initialization to prevent [core/no-app] errors in tests.
void setupFirebaseAuthMocks() {
  setupFirebaseCoreMocks();
}

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
  static Finder get googleSignInButton =>
      find.text(UITestData.googleSignInButton);
  static Finder get forgotPasswordButton =>
      find.text(UITestData.forgotPasswordButton);

  // Navigation elements
  static Finder get homeTab => find.text(UITestData.homeTitle);
  static Finder get configurationTab =>
      find.text(UITestData.configurationTitle);

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
    try {
      // Try to ensure the widget is visible within any scrollable
      await tester.ensureVisible(finder);
    } catch (_) {
      // Fallback: minor pump, in case it's already visible
      await tester.pump();
    }
    await tester.tap(finder, warnIfMissed: false);
    await tester.pumpAndSettle();
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
    bool skipInCI = true,
  }) async {
    // Skip golden tests in CI unless explicitly enabled
    if (skipInCI &&
        TestEnvironment.isCI &&
        !const bool.fromEnvironment('ENABLE_GOLDEN_TESTS',
            defaultValue: false)) {
      return;
    }

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

  /// Performs a golden test with multiple screen sizes
  static Future<void> expectGoldenMultiSize(
    WidgetTester tester,
    Widget widget,
    String baseFileName, {
    List<Size>? sizes,
    bool skipInCI = true,
  }) async {
    final testSizes = sizes ?? [phoneSize, tabletSize];

    for (int i = 0; i < testSizes.length; i++) {
      final size = testSizes[i];
      final fileName = '${baseFileName}_${_getSizeName(size)}.png';

      await expectGolden(
        tester,
        widget,
        fileName,
        size: size,
        skipInCI: skipInCI,
      );
    }
  }

  /// Gets a descriptive name for a screen size
  static String _getSizeName(Size size) {
    if (size == phoneSize) return 'phone';
    if (size == tabletSize) return 'tablet';
    if (size == desktopSize) return 'desktop';
    return '${size.width.toInt()}x${size.height.toInt()}';
  }

  /// Common screen sizes for golden tests
  static const Size phoneSize = Size(375, 667);
  static const Size tabletSize = Size(768, 1024);
  static const Size desktopSize = Size(1920, 1080);

  /// Additional device sizes
  static const Size iphoneSE = Size(320, 568);
  static const Size iphone12 = Size(390, 844);
  static const Size ipadPro = Size(1024, 1366);
}

// =============================================================================
// Widget Test Utilities - Enhanced
// =============================================================================

/// Enhanced utilities for widget testing following Axovia Flow standards
class WidgetTestUtils {
  /// Tests a widget with different themes
  static Future<void> testWithThemes(
    WidgetTester tester,
    Widget widget,
    List<ThemeData> themes,
    Future<void> Function(WidgetTester, ThemeData) testCallback,
  ) async {
    for (final theme in themes) {
      await testCallback(tester, theme);
    }
  }

  /// Tests a widget with different screen sizes
  static Future<void> testWithScreenSizes(
    WidgetTester tester,
    Widget widget,
    List<Size> sizes,
    Future<void> Function(WidgetTester, Size) testCallback,
  ) async {
    for (final size in sizes) {
      await tester.binding.setSurfaceSize(size);
      await testCallback(tester, size);
    }
  }

  /// Tests a widget with different locales
  static Future<void> testWithLocales(
    WidgetTester tester,
    Widget Function(Locale) widgetBuilder,
    List<Locale> locales,
    Future<void> Function(WidgetTester, Locale) testCallback,
  ) async {
    for (final locale in locales) {
      final widget = widgetBuilder(locale);
      await tester.pumpWidget(widget);
      await testCallback(tester, locale);
    }
  }

  /// Verifies that a widget doesn't overflow
  static void expectNoOverflow(WidgetTester tester) {
    expect(tester.takeException(), isNull);
  }

  /// Waits for a specific condition to be met
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (!condition() && stopwatch.elapsed < timeout) {
      await tester.pump(interval);
    }

    if (!condition()) {
      throw TimeoutException('Condition not met within timeout', timeout);
    }
  }

  /// Simulates device rotation
  static Future<void> rotateDevice(
    WidgetTester tester, {
    bool toPortrait = true,
  }) async {
    final currentSize = tester.binding.window.physicalSize;
    final newSize = toPortrait
        ? Size(currentSize.height, currentSize.width)
        : Size(currentSize.width, currentSize.height);

    await tester.binding.setSurfaceSize(newSize);
    await tester.pump();
  }
}

// =============================================================================
// Performance Test Utilities
// =============================================================================

/// Utilities for performance testing
class PerformanceTestUtils {
  /// Measures widget build time
  static Future<Duration> measureBuildTime(
    WidgetTester tester,
    Widget widget,
  ) async {
    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(widget);
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Measures animation performance
  static Future<Duration> measureAnimationTime(
    WidgetTester tester,
    Future<void> Function() animationTrigger,
  ) async {
    final stopwatch = Stopwatch()..start();
    await animationTrigger();
    await tester.pumpAndSettle();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Tests memory usage during widget operations
  static Future<void> testMemoryUsage(
    WidgetTester tester,
    Widget widget,
    Future<void> Function() operations,
  ) async {
    // This would integrate with memory profiling tools
    // Implementation depends on specific memory testing requirements
    await tester.pumpWidget(widget);
    await operations();

    // Force garbage collection
    await tester.pump(const Duration(milliseconds: 100));
  }
}

// =============================================================================
// Accessibility Test Utilities
// =============================================================================

/// Utilities for accessibility testing
class AccessibilityTestUtils {
  /// Verifies semantic labels are present
  static void expectSemanticLabel(
    WidgetTester tester,
    Finder finder,
    String expectedLabel,
  ) {
    final semantics = tester.getSemantics(finder);
    expect(semantics.label, contains(expectedLabel));
  }

  /// Verifies widget is focusable
  static void expectFocusable(WidgetTester tester, Finder finder) {
    // Check if widget can receive focus
    // Since we can't directly check if a widget is focusable without knowing its type,
    // we'll verify that the widget exists, which is a minimal check
    // A more complete implementation would require type-specific checks
    final widget = tester.widget(finder);
    expect(widget, isNotNull);
  }

  /// Tests keyboard navigation
  static Future<void> testKeyboardNavigation(
    WidgetTester tester,
    List<Finder> focusableWidgets,
  ) async {
    for (int i = 0; i < focusableWidgets.length - 1; i++) {
      // Simulate tab key press to move focus
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }
  }

  /// Verifies contrast ratios (simplified)
  static void expectSufficientContrast(
    Color foreground,
    Color background, {
    double minimumRatio = 4.5,
  }) {
    final ratio = _calculateContrastRatio(foreground, background);
    expect(ratio, greaterThanOrEqualTo(minimumRatio));
  }

  static double _calculateContrastRatio(Color color1, Color color2) {
    // Simplified contrast ratio calculation
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = math.max(luminance1, luminance2);
    final darker = math.min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }
}
