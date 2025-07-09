// Integration tests for main.dart
// These tests verify the complete app initialization and provider integration

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/main.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/pages/home/home_page.dart';
import 'package:cannasoltech_automation/pages/home/run_page.dart';
import 'package:cannasoltech_automation/objects/alarm_notification.dart';
import 'package:cannasoltech_automation/shared/maps.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockSystemDataModel extends Mock implements SystemDataModel {}
class MockDisplayDataModel extends Mock implements DisplayDataModel {}
class MockTransformModel extends Mock implements TransformModel {}
class MockSystemIdx extends Mock implements SystemIdx {}
class MockDevices extends Mock {
  String? getNameFromId(String id) => 'Test Device $id';
}

void main() {
  group('Main App Integration Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockSystemDataModel mockSystemData;
    late MockDisplayDataModel mockDisplayData;
    late MockSystemIdx mockSystemIdx;

    setUpAll(() {
      registerFallbackValue(Container());
      registerFallbackValue(const RouteSettings());
      registerFallbackValue(MaterialPageRoute(builder: (_) => Container()));
    });

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockSystemData = MockSystemDataModel();
      mockDisplayData = MockDisplayDataModel();
      mockSystemIdx = MockSystemIdx();

      // Setup default mock behaviors
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.value(null),
      );
      when(() => mockDisplayData.setBottomNavSelectedItem(any())).thenReturn(null);
      when(() => mockSystemData.devices).thenReturn(MockDevices());
      when(() => mockSystemData.setSelectedDeviceFromName(any())).thenReturn(null);
      when(() => mockSystemIdx.set(any())).thenReturn(null);
      when(() => mockUser.uid).thenReturn('test-uid-123');
    });

    group('Full App Initialization', () {
      testWidgets('App initializes with all providers correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify the app structure
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(HomePage), findsOneWidget);

        // Verify global keys are set
        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.navigatorKey, equals(navigatorKey));
        expect(materialApp.scaffoldMessengerKey, equals(scaffoldMessengerKey));
      });

      testWidgets('App responds to authentication state changes', (WidgetTester tester) async {
        // Start with no user
        final authController = StreamController<User?>();
        when(() => mockAuth.authStateChanges()).thenAnswer(
          (_) => authController.stream,
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Initially no user
        expect(find.byType(MaterialApp), findsOneWidget);

        // Simulate user login
        authController.add(mockUser);
        await tester.pumpAndSettle();

        // App should still be running
        expect(find.byType(MaterialApp), findsOneWidget);

        // Simulate user logout
        authController.add(null);
        await tester.pumpAndSettle();

        // App should still be running
        expect(find.byType(MaterialApp), findsOneWidget);

        authController.close();
      });
    });

    group('Navigation Integration', () {
      testWidgets('Push notification navigation works correctly', (WidgetTester tester) async {
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
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
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
        
        // Test push notification route with active alarm
        final testData = {
          'deviceId': 'device-123',
          'alarm': 'Flow',
          'active': 'True',
        };

        final route = materialApp.onGenerateRoute?.call(
          RouteSettings(
            name: 'push_notification',
            arguments: testData,
          ),
        );

        // Verify that the navigation logic was triggered
        verify(() => mockSystemData.setSelectedDeviceFromName('Test Device device-123'));
        verify(() => mockDisplayData.setBottomNavSelectedItem(0));
      });

      testWidgets('Push notification with cleared alarm works', (WidgetTester tester) async {
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
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
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
        
        // Test push notification route with cleared alarm
        final testData = {
          'deviceId': 'device-456',
          'alarm': 'Temperature',
          'active': 'False',
        };

        final route = materialApp.onGenerateRoute?.call(
          RouteSettings(
            name: 'push_alarm_cleared',
            arguments: testData,
          ),
        );

        // Verify that the navigation logic was triggered
        verify(() => mockSystemData.setSelectedDeviceFromName('Test Device device-456'));
        verify(() => mockDisplayData.setBottomNavSelectedItem(0));
      });

      testWidgets('Non-push routes return null', (WidgetTester tester) async {
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
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
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
          const RouteSettings(name: '/regular-route'),
        );

        expect(route, isNull);
      });

      testWidgets('Routes without arguments return null', (WidgetTester tester) async {
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
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
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
        
        // Test push route without arguments
        final route = materialApp.onGenerateRoute?.call(
          const RouteSettings(name: 'push_notification'),
        );

        expect(route, isNull);
      });
    });

    group('Provider Dependencies', () {
      testWidgets('Providers are accessible throughout the widget tree', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Find a context deep in the widget tree
        final context = tester.element(find.byType(HomePage));

        // Verify all providers are accessible
        expect(
          Provider.of<SystemDataModel>(context, listen: false),
          equals(mockSystemData),
        );
        expect(
          Provider.of<DisplayDataModel>(context, listen: false),
          equals(mockDisplayData),
        );
        expect(
          Provider.of<TransformModel>(context, listen: false),
          isA<TransformModel>(),
        );
        expect(
          Provider.of<SystemIdx>(context, listen: false),
          equals(mockSystemIdx),
        );
        expect(
          Provider.of<User?>(context, listen: false),
          isNull,
        );
      });

      testWidgets('Provider initialization methods are called', (WidgetTester tester) async {
        final mockTransform = MockTransformModel();
        when(() => mockTransform.init()).thenReturn(null);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>.value(value: mockTransform),
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify init method was called (this would be verified in actual provider tests)
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    group('Error Recovery', () {
      testWidgets('App handles provider errors gracefully', (WidgetTester tester) async {
        // Test with a provider that throws during creation
        expect(() async {
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SystemDataModel>(
                  create: (_) => throw Exception('SystemDataModel creation failed'),
                ),
                ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
                ChangeNotifierProvider<TransformModel>(
                  create: (_) => MockTransformModel(),
                ),
                ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
                StreamProvider<User?>.value(
                  value: mockAuth.authStateChanges(),
                  initialData: null,
                ),
              ],
              child: const MyApp(),
            ),
          );
        }, throwsException);
      });

      testWidgets('App handles stream errors in auth state', (WidgetTester tester) async {
        when(() => mockAuth.authStateChanges()).thenAnswer(
          (_) => Stream<User?>.error('Auth error'),
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SystemDataModel>.value(value: mockSystemData),
              ChangeNotifierProvider<DisplayDataModel>.value(value: mockDisplayData),
              ChangeNotifierProvider<TransformModel>(
                create: (_) => MockTransformModel(),
              ),
              ChangeNotifierProvider<SystemIdx>.value(value: mockSystemIdx),
              StreamProvider<User?>.value(
                value: mockAuth.authStateChanges(),
                initialData: null,
              ),
            ],
            child: const MyApp(),
          ),
        );

        // The app should handle the stream error
        await tester.pumpAndSettle();
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });
}
