import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/features/auth/screen/forget_password/forget_password_screen.dart';
import 'package:gurme/features/auth/screen/login/login_screen.dart';
import 'package:gurme/features/auth/screen/signup/signup_screen.dart';
import 'package:gurme/features/splash/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const MaterialPage(child: SplashScreen());
      },
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginScreen());
      },
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) {
        return const MaterialPage(child: SignUpScreen());
      },
    ),
    GoRoute(
      path: '/forgotpassword',
      pageBuilder: (context, state) {
        return const MaterialPage(child: ForgetPasswordScreen());
      },
    ),
  ],
);
