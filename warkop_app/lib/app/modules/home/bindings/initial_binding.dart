import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
//import '../controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
