import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:test/screens/add_taskbar.dart';
import 'package:test/screens/home.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FirstApp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Dashboard()),
        GetPage(name: '/add-task', page: () => AddTaskPage()),
      ],
    );
  }
}
