import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/screen/forget_password/forget_password_screen.dart';
import 'package:gurme/features/auth/screen/login/login_screen.dart';
import 'package:gurme/features/auth/screen/signup/signup_screen.dart';
import 'package:gurme/features/company/company_screen.dart';
import 'package:gurme/features/home/screen/home_screen.dart';
import 'package:gurme/features/search/screen/search_screen.dart';
import 'package:gurme/features/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          },
        ),
        GoRoute(
          name: RouteConstants.loginScreen,
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          },
        ),
        GoRoute(
          name: RouteConstants.signUpScreen,
          path: '/signup',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SignUpScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.ease))),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          name: RouteConstants.forgotPasswordScreen,
          path: '/forgotpassword',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const ForgetPasswordScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.ease))),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          name: RouteConstants.homeScreen,
          path: "/home",
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomeScreen());
          },
        ),
        GoRoute(
          name: RouteConstants.companyScreen,
          path: "/",
          pageBuilder: (context, state) {
            return const MaterialPage(child: CompanyScreen());
          },
        ),
      ],
    );
  },
);
