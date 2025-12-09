import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:gems_core/gems_core.dart';

import 'routes/app_pages.dart';
import 'services/app_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services using get_it
  final appServices = AppServices();
  await appServices.initialize(
    environmentMode: EnvironmentMode.development,
    appConfig: AppConfig(
      apiBaseUrl: 'https://jsonplaceholder.typicode.com',
      enableLogging: true,
      apiTimeout: const Duration(seconds: 30),
    ),
  );

  runApp(const FlutterGemsApp());
}

class FlutterGemsApp extends StatelessWidget {
  const FlutterGemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        ResponsiveHelper.baseWidth,
        ResponsiveHelper.baseHeight,
      ),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          title: 'Flutter Gems - Todo Example',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          getPages: AppPages.routes,
          routerDelegate: GetDelegate(),
          routeInformationParser: GetInformationParser(
            initialRoute: AppRoutes.home,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
