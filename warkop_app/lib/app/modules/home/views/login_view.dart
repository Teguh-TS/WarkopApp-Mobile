import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

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
                hintText: 'Email/Username', controller: emailController),
            CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () {
                controller.email.value = emailController.text;
                controller.password.value = passwordController.text;
                controller.login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
