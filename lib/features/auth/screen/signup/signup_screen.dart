import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/widgets/square_tile.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/auth/screen/signup/signup_form.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  void loseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void signUpWithEmail(BuildContext context, WidgetRef ref, String email,
      String password, String name) {
    ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(context, email, password, name);
  }

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GestureDetector(
        onTap: loseFocus,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 19,
                ),
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
                            Icons.close,
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Text(
                        "Kayıt Ol",
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 34,
                ),
                const SignUpForm(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Ya da şununla kayıt ol",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SquareTile(
                  imagePath: AssetConstants.googleLogo,
                  onTap: () {
                    signInWithGoogle(context, ref);
                  },
                ),
                Container(
                  height: 100,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabın var mı? ",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go("/login");
                        },
                        child: Text(
                          "Giriş Yap",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
