import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo.shade400,
        child: Center(
          child: Image.asset(
            "assets/images/splash_logo_white.png",
            width: MediaQuery.of(context).size.width / 1.5,
          ),
        ),
      ),
    );
  }
}
