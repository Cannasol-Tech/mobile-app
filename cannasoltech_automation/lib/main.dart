/**
 * @file main.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Main entry point for the Cannasol Technologies Automation Flutter application.
 * @details This file initializes Firebase, sets up providers for state management,
 *          and configures the main application widget with routing and authentication.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/services/navigation_service.dart';
import 'package:cannasoltech_automation/services/logging_service.dart';
import 'package:cannasoltech_automation/services/style_service.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'objects/alarm_notification.dart';
import 'pages/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home/run_page.dart';
import 'providers/transform_provider.dart';
import 'shared/maps.dart';

/// Type alias for Firebase Auth User, representing the current authenticated user
typedef CurrentUser = User?;

// Initialize services
final _navigationService = NavigationService();

// Backward compatibility: expose service keys as global variables
final navigatorKey = _navigationService.navigatorKey;
final scaffoldMessengerKey = _navigationService.scaffoldMessengerKey;



/// Global scaffold messenger key for displaying snackbars and banners
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/**
 * @brief Main entry point of the Flutter application.
 * @details Initializes Flutter bindings, Firebase services, logging, and sets up
 *          the provider hierarchy for state management. Handles Firebase initialization
 *          errors gracefully to allow development without Firebase.
 * @throws Exception if critical initialization fails
 * @since 1.0
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with better error handling for web
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Only initialize notifications if not on web (web doesn't support FCM the same way)
    try {
      await FirebaseApi().initNotifications();
    } catch (notificationError) {
      print('Notification initialization failed (expected on web): $notificationError');
    }
    firebaseInitialized = true;
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase for development
  }

  // Initialize services
  final navigationService = _navigationService; // Use the already created instance
  final loggingService = LoggingService();
  final styleService = StyleService();
  
  runApp(
    MultiProvider(
    providers: [
          // Service providers
          Provider<NavigationService>.value(value: navigationService),
          Provider<LoggingService>.value(value: loggingService),
          Provider<StyleService>.value(value: styleService),
          
          // Existing providers
          // StreamProvider<Data>(create: (context) => DatabaseService().streamDevices(), initialData: Data(devices: [])),
          // StreamProvider<UserDbInfo>(create: (context) => DatabaseService().streamUser(), initialData: UserDbInfo.noUser()),
          ChangeNotifierProvider(create: (context) {
            var sysIdx = SystemIdx();
            sysIdx.init();
            return sysIdx;
         }),
          ChangeNotifierProvider(create: (context) {
            var systemDataModel = SystemDataModel();
            systemDataModel.setLoggingService(loggingService);
            systemDataModel.init();
            return systemDataModel;
          }),
          ChangeNotifierProvider(create: (context) {
            var transformModel = TransformModel();
            transformModel.init();
            return transformModel;
          }),
          ChangeNotifierProvider(create: (context) => DisplayDataModel()),
          // Provide Firebase Auth stream if Firebase is initialized
          StreamProvider<CurrentUser>.value(
            value: firebaseInitialized ? FirebaseAuth.instance.authStateChanges() : Stream.value(null),
            initialData: null,
          ),
        ],
      child: const MyApp()
      ),
    );
}

/**
 * @brief Root widget of the Cannasol Technologies Automation application.
 * @details Configures the MaterialApp with theme, routing, and authentication state.
 *          Handles push notification routing and alarm notifications.
 * @since 1.0
 */
class MyApp extends StatelessWidget {
  /**
   * @brief Creates a MyApp widget.
   * @param key Optional widget key for identification
   */
  const MyApp({super.key});

  /**
   * @brief Builds the root MaterialApp widget.
   * @details Sets up the app theme, navigation, and routing logic including
   *          special handling for push notification routes and alarm displays.
   * @param context The build context
   * @return MaterialApp configured with theme and routing
   * @since 1.0
   */
  @override
  Widget build(BuildContext context) {
    bool loggedIn = Provider.of<CurrentUser>(context) != null;

    return  MaterialApp(
      title: 'Cannasol Technologies Automation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const HomePage(), // Restored original home page
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      onGenerateRoute: (settings) {
        if (loggedIn && settings.name != null && settings.arguments != null){
          if (settings.name!.contains("push")){
            final data = settings.arguments as Map;
            dynamic sys = context.read<SystemDataModel>();
            String? deviceName = sys.devices.getNameFromId(data['deviceId']);
            sys.setSelectedDeviceFromName(deviceName);
            if (data['active'] == 'False'){
              ClearedAlarmNotification(alarmName: data['alarm'], deviceId: data['deviceId']).showAlarmBanner();
            } else{
              AlarmNotification(alarmName: data['alarm'], deviceId: data['deviceId']).showAlarmBanner();
            }
            navigatorKey.currentContext?.read<DisplayDataModel>().setBottomNavSelectedItem(0);
            navigatorKey.currentState?.pop();
            return MaterialPageRoute(
              builder: (context) {
                int idx = alarmToIdxMap[data['alarm']];
                context.read<SystemIdx>().set(idx);  
                return const RunPage();
              }
            );
          }
        }
        return null;
      },
    );
  }
}

/**
 * @brief Temporary test page to verify basic Flutter functionality.
 * @details Simple page displaying test content to ensure the Flutter app
 *          is rendering correctly during development and testing phases.
 * @deprecated This is a temporary test widget and should be removed in production
 * @since 1.0
 */
class TestHomePage extends StatelessWidget {
  /**
   * @brief Creates a TestHomePage widget.
   * @param key Optional widget key for identification
   */
  const TestHomePage({super.key});

  /**
   * @brief Builds the test page with basic UI elements.
   * @details Creates a scaffold with app bar and centered content including
   *          test text and a loading indicator to verify rendering.
   * @param context The build context
   * @return Scaffold widget with test content
   * @since 1.0
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cannasol Technologies - Test'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter App is Working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'This is a test page to verify the app is rendering correctly.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
