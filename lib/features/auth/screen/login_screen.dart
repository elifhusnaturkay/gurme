import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle(context);
  }

  void signInWithEmail(
      BuildContext context, WidgetRef ref, String email, String password) {
    ref.read(authControllerProvider).signInWithEmail(context, email, password);
  }

  void signUpWithEmail(
      BuildContext context, WidgetRef ref, String email, String password) {
    ref.read(authControllerProvider).signUpWithEmail(context, email, password);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              signInWithGoogle(context, ref);
            },
            child: const Text('Login with Google'),
          ),
          TextField(
            controller: emailController,
          ),
          TextField(
            controller: passwordController,
          ),
          ElevatedButton(
            onPressed: () {
              signUpWithEmail(
                  context, ref, emailController.text, passwordController.text);
            },
            child: const Text('Sign up with email'),
          ),
          ElevatedButton(
            onPressed: () {
              signInWithEmail(
                  context, ref, emailController.text, passwordController.text);
            },
            child: const Text('Login with email'),
          ),
        ],
      ),
    );
  }
}
