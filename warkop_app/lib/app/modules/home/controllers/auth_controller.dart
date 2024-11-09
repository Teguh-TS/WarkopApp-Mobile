import 'package:get/get.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var confirmPassword = ''.obs;

  void login() {
    // Logika login
    print("Email: ${email.value}, Password: ${password.value}");
  }

  void register() {
    // Logika register
    print("Nama Depan: ${firstName.value}, Nama Belakang: ${lastName.value}");
  }
}
