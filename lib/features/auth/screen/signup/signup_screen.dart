import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/lose_focus.dart';
import 'package:gurme/common/widgets/square_tile.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/auth/screen/signup/signup_form.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle();
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
                  while (GoRouter.of(context).location !=
                      '/${RouteConstants.homeScreen}') {
                    debugPrint(GoRouter.of(context).location.toString());
                    context.pop();
                  }
                  signInWithGoogle(ref);
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
                          "Hesabın var mı? ",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
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
