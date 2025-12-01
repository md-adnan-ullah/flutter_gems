import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/app_services.dart';
import 'pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services
  await AppServices.instance.initialize();

  runApp(const FlutterGemsApp());
}

class FlutterGemsApp extends StatelessWidget {
  const FlutterGemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Gems - Todo Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
