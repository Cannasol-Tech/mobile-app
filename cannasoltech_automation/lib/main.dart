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

typedef CurrentUser = User?;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(name: "cannasoltech", options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseApi().initNotifications();
  } catch (e) {
    // Optionally show an error screen if Firebase fails to initialize
  }
  
  // Initialize services
  final navigationService = NavigationService();
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
          StreamProvider<CurrentUser>.value(value: FirebaseAuth.instance.authStateChanges(), initialData: null,),
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
    final navigationService = Provider.of<NavigationService>(context);
    
    Future.microtask(() {
      context.read<DisplayDataModel>().setBottomNavSelectedItem(0);
    });
    return  MaterialApp(
      title: 'Cannasol Technologies Automation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      navigatorKey: navigationService.navigatorKey,
      scaffoldMessengerKey: navigationService.scaffoldMessengerKey,
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
            navigationService.currentContext?.read<DisplayDataModel>().setBottomNavSelectedItem(0);
            navigationService.pop();
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
