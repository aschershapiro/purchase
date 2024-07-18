import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchase/controller.dart';
import 'package:purchase/database.dart';
import 'package:purchase/login_page.dart';
import 'package:purchase/routes.dart';

late final Controller c;
final database = Database();
void main() async {
  c = Get.put(Controller());
  await database.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PFP Purchase Order Management',
      getPages: appRoutes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
