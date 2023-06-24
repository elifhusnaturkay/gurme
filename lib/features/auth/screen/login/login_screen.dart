import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/widgets/square_tile.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/auth/screen/login/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signInAnonymously(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInAnonymously(context);
  }

  void loseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
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
                const SizedBox(height: 19),
                Center(
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                Row(
                  children: [
                    const Spacer(),
                    SquareTile(
                      imagePath: AssetConstants.googleLogo,
                      onTap: () {
                        signInWithGoogle(context, ref);
                      },
                    ),
                    const Spacer(flex: 1),
                    SquareTile(
                      imagePath: AssetConstants.anonymousUser,
                      onTap: () {
                        signInAnonymously(context, ref);
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                Container(
                  height: 100,
                  alignment: Alignment.bottomCenter,
                  child: Row(
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
                          context.push("/signup");
                        },
                        child: Text(
                          "Kayıt ol",
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
