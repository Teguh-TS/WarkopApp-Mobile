import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input untuk email
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
            ),
            // Input untuk password
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            // Tombol Login
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 185, 27, 16),
                foregroundColor: const Color.fromARGB(
                    255, 241, 217, 130), // Warna teks putih
              ),
              onPressed: () async {
                // Mengambil input email dan password
                controller.email.value = emailController.text;
                controller.password.value = passwordController.text;

                // Panggil fungsi login dan arahkan ke HomeView setelah berhasil
                await controller.login();

                // Navigasi ke HomeView jika login sukses
                if (controller.firebaseUser.value != null) {
                  print("User is authenticated. Redirecting to HOME...");
                  print("Navigating to HomeView...");
                  Get.offAllNamed(Routes.HOME);
                  print("Navigation to HomeView completed.");
                } else {
                  print("User is null. Staying at LOGIN view...");
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
