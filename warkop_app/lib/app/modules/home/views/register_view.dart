import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
            ),
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 185, 27, 16),
                foregroundColor: const Color.fromARGB(255, 241, 217, 130),
              ),
              onPressed: () {
                controller.email.value = emailController.text;
                controller.password.value = passwordController.text;
                controller.register();
                if (controller.firebaseUser.value != null) {
                  Get.toNamed(Routes
                      .LOGIN); // Menggunakan GetX untuk navigasi ke LoginView
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
