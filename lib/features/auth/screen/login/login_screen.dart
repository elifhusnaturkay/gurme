import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/widgets/square_tile.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/auth/screen/login/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void loseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: loseFocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 19),
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      "Giriş Yap",
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const LoginForm(),
              const SizedBox(height: 50),
              Text(
                "Ya da şununla giriş yap",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              SquareTile(
                imagePath: AssetConstants.googleLogo,
                onTap: () {
                  signInWithGoogle(context, ref);
                },
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Henüz bir hesabın yok mu? ",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteConstants.signUpScreen);
                          },
                          child: Text(
                            "Kayıt ol",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.indigo.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
