import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'objects/alarm_notification.dart';
import 'pages/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home/run_page.dart';
import 'providers/transform_provider.dart';
import 'shared/maps.dart';
import 'objects/logger.dart';

typedef CurrentUser = User?;

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();



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

  setupLogging();
  runApp(
    MultiProvider(
    providers: [
          ChangeNotifierProvider(create: (context) {
            var sysIdx = SystemIdx();
            sysIdx.init();
            return sysIdx;
         }),
          ChangeNotifierProvider(create: (context) {
            var systemDataModel = SystemDataModel();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool loggedIn = Provider.of<CurrentUser>(context) != null;
    // Removed problematic DisplayDataModel initialization for now
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

// Temporary test page to verify basic Flutter functionality
class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

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
