import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => context.go("/login"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo.shade400,
      child: Center(
        child: Image.asset(
          "assets/images/splash_logo_white.png",
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }
}
