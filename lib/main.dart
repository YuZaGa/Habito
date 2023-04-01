import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:test/screens/add_taskbar.dart';
import 'package:test/screens/home.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/screens/onboarding.dart';
import 'package:test/screens/settings.dart';

import 'models/task.dart';

bool onboardingShown = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskAdapter());
  }

  await Hive.openBox(HiveBoxes.userBox);
  Box box = Hive.box(HiveBoxes.userBox);
  onboardingShown = box.get('onboardingShown') ?? false;
  await Hive.openBox<Task>('tasks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FirstApp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: onboardingShown ? Dashboard() : OnboardingScreen(),
      getPages: [
        GetPage(name: '/', page: () => Dashboard()),
        GetPage(name: '/add-task', page: () => AddTaskPage()),
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
    );
  }
}
