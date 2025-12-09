import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/nav_shell.dart';
import '../pages/settings_page.dart';
import '../pages/todo_page.dart';

class AppRoutes {
  static const root = '/';
  static const home = '/home';
  static const todos = '/todos';
  static const settings = '/settings';
}

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.root,
      page: () => const NavShell(),
      participatesInRootNavigator: true,
      children: [
        GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(),
        ),
        GetPage(
          name: AppRoutes.todos,
          page: () => const TodoPage(),
        ),
        GetPage(
          name: AppRoutes.settings,
          page: () => const SettingsPage(),
        ),
      ],
    ),
  ];
}

