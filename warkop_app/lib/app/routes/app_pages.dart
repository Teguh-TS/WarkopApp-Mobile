import 'package:get/get.dart';
import 'package:warkop_app/app/modules/home/views/about_view.dart';
import 'package:warkop_app/app/modules/home/views/login_view.dart';
import 'package:warkop_app/app/modules/home/views/menu_view.dart';
import 'package:warkop_app/app/modules/home/views/order_view.dart';
import 'package:warkop_app/app/modules/home/views/register_view.dart';
import 'package:warkop_app/app/modules/home/views/welcome_view.dart';
import 'package:warkop_app/app/modules/home/views/home_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/controllers/auth_controller.dart';
import '../modules/home/controllers/home_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Awali dengan WelcomeView
  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: _Paths.MENU,
      page: () => MenuView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: HomeBinding(),
    ),
  ];
}
