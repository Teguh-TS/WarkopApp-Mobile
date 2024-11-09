import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'First Name',
                    controller: firstNameController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    hintText: 'Last Name',
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            CustomTextField(hintText: 'Email', controller: emailController),
            CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                isPassword: true),
            CustomTextField(
                hintText: 'Password Confirm',
                controller: confirmPasswordController,
                isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () {
                controller.firstName.value = firstNameController.text;
                controller.lastName.value = lastNameController.text;
                controller.email.value = emailController.text;
                controller.password.value = passwordController.text;
                controller.confirmPassword.value =
                    confirmPasswordController.text;
                controller.register();
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
