import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';
import 'register_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/logo.png',
            height: 100,
          ),
          const SizedBox(height: 20),
          /*const Text(
            'DRINKS',
            style: TextStyle(
              fontSize: 24,
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
            ),
          ),*/
          const SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 185, 27, 16),
              foregroundColor: const Color.fromARGB(255, 241, 217, 130),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () => Get.to(() => const LoginView()),
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () => Get.to(() => const RegisterView()),
            child:
                const Text('Register', style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }
}
