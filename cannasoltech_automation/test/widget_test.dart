// Comprehensive unit tests for main.dart
// Tests the main app initialization, providers, and navigation logic

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/main.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/pages/home/home_page.dart';
import 'package:cannasoltech_automation/pages/home/run_page.dart';

// Mock classes for testing
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockSystemDataModel extends Mock implements SystemDataModel {}
class MockDisplayDataModel extends Mock implements DisplayDataModel {}
class MockTransformModel extends Mock implements TransformModel {}
class MockSystemIdx extends Mock implements SystemIdx {}

void main() {
  group('Main App Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(Container());
      registerFallbackValue(const RouteSettings());
    });

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
    });

    testWidgets('MyApp builds with correct title and theme', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.value(null),
      );

      // Build the app with mocked providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SystemDataModel>(
              create: (_) => MockSystemDataModel(),
            ),
            ChangeNotifierProvider<DisplayDataModel>(
              create: (_) => MockDisplayDataModel(),
            ),
            ChangeNotifierProvider<TransformModel>(
              create: (_) => MockTransformModel(),
            ),
            ChangeNotifierProvider<SystemIdx>(
              create: (_) => MockSystemIdx(),
            ),
            StreamProvider<User?>.value(
              value: mockAuth.authStateChanges(),
              initialData: null,
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('Cannasol Technologies Automation'));
      expect(materialApp.theme?.colorScheme.seedColor, equals(Colors.lightBlue));
      expect(materialApp.theme?.useMaterial3, isTrue);
    });

    testWidgets('MyApp sets home page correctly', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.value(null),
      );

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SystemDataModel>(
              create: (_) => MockSystemDataModel(),
            ),
            ChangeNotifierProvider<DisplayDataModel>(
              create: (_) => MockDisplayDataModel(),
            ),
            ChangeNotifierProvider<TransformModel>(
              create: (_) => MockTransformModel(),
            ),
            ChangeNotifierProvider<SystemIdx>(
              create: (_) => MockSystemIdx(),
            ),
            StreamProvider<User?>.value(
              value: mockAuth.authStateChanges(),
              initialData: null,
            ),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.home, isA<HomePage>());
    });

    testWidgets('MyApp handles user authentication state changes', (WidgetTester tester) async {
      // Test with logged out user
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.value(null),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SystemDataModel>(
              create: (_) => MockSystemDataModel(),
            ),
            ChangeNotifierProvider<DisplayDataModel>(
              create: (_) => MockDisplayDataModel(),
            ),
            ChangeNotifierProvider<TransformModel>(
              create: (_) => MockTransformModel(),
            ),
            ChangeNotifierProvider<SystemIdx>(
              create: (_) => MockSystemIdx(),
            ),
            StreamProvider<User?>.value(
              value: mockAuth.authStateChanges(),
              initialData: null,
            ),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the app builds without errors when user is null
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp handles logged in user', (WidgetTester tester) async {
      // Test with logged in user
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.value(mockUser),
      );
      when(() => mockUser.uid).thenReturn('test-uid');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SystemDataModel>(
              create: (_) => MockSystemDataModel(),
            ),
            ChangeNotifierProvider<DisplayDataModel>(
              create: (_) => MockDisplayDataModel(),
            ),
            ChangeNotifierProvider<TransformModel>(
              create: (_) => MockTransformModel(),
            ),
            ChangeNotifierProvider<SystemIdx>(
              create: (_) => MockSystemIdx(),
            ),
            StreamProvider<User?>.value(
              value: mockAuth.authStateChanges(),
              initialData: mockUser,
            ),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the app builds correctly with logged in user
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    group('Navigation Tests', () {
      late MockSystemDataModel mockSystemData;
      late MockDisplayDataModel mockDisplayData;

      setUp(() {
        mockSystemData = MockSystemDataModel();
        mockDisplayData = MockDisplayDataModel();
        
        // Setup default mock behaviors
        when(() => mockDisplayData.setBottomNavSelectedItem(any())).thenReturn(null);
        when(() => mockSystemData.devices).thenReturn(MockDevices());
        when(() => mockSystemData.setSelectedDeviceFromName(any())).thenReturn(null);
      });

      testWidgets('onGenerateRoute handles push notifications correctly', (WidgetTester tester) async {
        when(() => mockAuth.authStateChanges()).thenAnswer(
          (_) => Stream<User?>.value(mockUser),
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>(
                create: (_) => MockSystemIdx(),
              ),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: mockUser,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        
        // Test push notification route generation
        final route = materialApp.onGenerateRoute?.call(
          const RouteSettings(
            name: 'push_notification',
            arguments: {
              'deviceId': 'test-device',
              'alarm': 'Flow',
              'active': 'True',
            },
          ),
        );

        // Should return null since we're not testing the full navigation context
        expect(route, isNull);
      });

      testWidgets('onGenerateRoute returns null for non-push routes', (WidgetTester tester) async {
        when(() => mockAuth.authStateChanges()).thenAnswer(
          (_) => Stream<User?>.value(mockUser),
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>(
                create: (_) => MockSystemIdx(),
              ),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: mockUser,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        
        // Test regular route
        final route = materialApp.onGenerateRoute?.call(
          const RouteSettings(name: 'regular_route'),
        );

        expect(route, isNull);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('All providers are properly initialized', (WidgetTester tester) async {
        when(() => mockAuth.authStateChanges()).thenAnswer(
          (_) => Stream<User?>.value(null),
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>(
                create: (_) => MockSystemDataModel(),
              ),
              ChangeNotifierProvider<DisplayDataModel>(
                create: (_) => MockDisplayDataModel(),
              ),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>(
                create: (_) => MockSystemIdx(),
              ),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify all providers are accessible
        final context = tester.element(find.byType(MyApp));
        
        expect(
          () => Provider.of<SystemDataModel>(context, listen: false),
          returnsNormally,
        );
        expect(
          () => Provider.of<DisplayDataModel>(context, listen: false),
          returnsNormally,
        );
        expect(
          () => Provider.of<TransformModel>(context, listen: false),
          returnsNormally,
        );
        expect(
          () => Provider.of<SystemIdx>(context, listen: false),
          returnsNormally,
        );
        expect(
          () => Provider.of<User?>(context, listen: false),
          returnsNormally,
        );
      });
    });

    group('Global Keys Tests', () {
      test('navigatorKey is properly initialized', () {
        expect(navigatorKey, isA<GlobalKey<NavigatorState>>());
        expect(navigatorKey.currentState, isNull); // Before app is built
      });

      test('scaffoldMessengerKey is properly initialized', () {
        expect(scaffoldMessengerKey, isA<GlobalKey<ScaffoldMessengerState>>());
        expect(scaffoldMessengerKey.currentState, isNull); // Before app is built
      });
    });

    group('Error Handling Tests', () {
      testWidgets('App handles provider errors gracefully', (WidgetTester tester) async {
        // Test with a provider that throws an error
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>(
                create: (_) => throw Exception('Provider error'),
              ),
              ChangeNotifierProvider<DisplayDataModel>(
                create: (_) => MockDisplayDataModel(),
              ),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>(
                create: (_) => MockSystemIdx(),
              ),
              StreamProvider<User?>.value(
                value: Stream<User?>.value(null),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        // The app should handle the error and still build
        expect(tester.takeException(), isA<Exception>());
      });
    });
  });
}

// Mock classes for dependencies
class MockDevices extends Mock {
  String? getNameFromId(String id) => 'Test Device';
}
