import 'package:get/get.dart';
import 'package:warkop_app/app/modules/home/views/about_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_about_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_home_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_menu_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_order_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_profile_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_view.dart';
import 'package:warkop_app/app/modules/home/views/booking_view.dart';
import 'package:warkop_app/app/modules/home/views/dashboard_view.dart';
import 'package:warkop_app/app/modules/home/views/event_page.dart';
import 'package:warkop_app/app/modules/home/views/login_view.dart';
import 'package:warkop_app/app/modules/home/views/menu_view.dart';
import 'package:warkop_app/app/modules/home/views/order_view.dart';
import 'package:warkop_app/app/modules/home/views/profile_view.dart';
import 'package:warkop_app/app/modules/home/views/register_view.dart';
import 'package:warkop_app/app/modules/home/views/review_view.dart';
import 'package:warkop_app/app/modules/home/views/setting_view.dart';
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
      name: _Paths.ADMIN,
      page: () => AdminView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => AdminHomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MENU,
      page: () => AdminMenuView(
        selectedMenus: [],
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_ORDER,
      page: () => AdminOrderView(
        selectedMenus: [],
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_ABOUT,
      page: () => AdminAboutView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PROFILE,
      page: () => AdminProfileView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MENU,
      page: () => MenuView(
        selectedMenus: [],
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(
        selectedMenus: [],
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => EventPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => ReviewView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => BookingView(),
      binding: HomeBinding(),
    ),
  ];
}
