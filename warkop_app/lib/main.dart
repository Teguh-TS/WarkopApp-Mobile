import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warkop_app/app/modules/home/controllers/setting_controller.dart';
import 'app/modules/home/bindings/initial_binding.dart';
import 'app/modules/home/controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  Get.put(SettingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages
          .INITIAL, // Menggunakan AppPages.INITIAL sebagai initial route
      initialBinding: InitialBinding(),
      getPages: AppPages.routes, // Menggunakan daftar routes dari AppPages
    );
  }
}
