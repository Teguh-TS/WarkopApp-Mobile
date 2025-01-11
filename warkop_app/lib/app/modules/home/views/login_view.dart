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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Input untuk email
              CustomTextField(
                hintText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 20),
              // Input untuk password
              CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              // Tombol Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 185, 27, 16),
                  foregroundColor: const Color.fromARGB(255, 241, 217, 130),
                ),
                onPressed: () async {
                  controller.email.value = emailController.text;
                  controller.password.value = passwordController.text;
                  await controller.login();

                  if (controller.firebaseUser.value != null) {
                    // Check the role of the user in Firestore
                    var userDoc = await controller.firestore
                        .collection('users')
                        .doc(controller.firebaseUser.value!.uid)
                        .get();

                    if (userDoc.exists) {
                      String role = userDoc.data()?['role'] ?? 'user';

                      if (role == 'admin') {
                        // Redirect to AdminView if role is 'admin'
                        Get.offAllNamed(Routes.ADMIN);
                      } else {
                        // Redirect to HomeView if role is 'user'
                        Get.offAllNamed(Routes.HOME);
                      }
                    } else {
                      // Handle case if the user doesn't have a document in Firestore
                      Get.snackbar('Error', 'User data not found');
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
