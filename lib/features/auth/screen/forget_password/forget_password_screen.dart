import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/features/auth/constants/auth_constants.dart';
import 'package:gurme/features/auth/screen/forget_password/forget_password_form.dart';

class ForgetPasswordScreen extends ConsumerWidget {
  const ForgetPasswordScreen({super.key});

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
                        AuthConstants.SifreniSifirla,
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const ForgetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
