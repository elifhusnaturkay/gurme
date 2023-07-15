import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/lose_focus.dart';
import 'package:gurme/common/widgets/submit_button.dart';
import 'package:gurme/common/widgets/form_fields.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInWithEmail(
      WidgetRef ref, String email, String password) async {
    await ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DefaultTextFormField(
              controller: emailController,
              hintText: "Email",
              validator: emailValidator,
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PasswordFormField(
              controller: passwordController,
              hintText: "Şifre",
              validator: passwordValidator,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteConstants.forgotPasswordScreen);
                  },
                  child: Text(
                    "Şifreni mi unuttun?",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SubmitButton(
            onTap: () async {
              loseFocus();
              if (_formKey.currentState!.validate()) {
                context.pop();
                await signInWithEmail(
                  ref,
                  emailController.text,
                  passwordController.text,
                );
              }
            },
            text: 'Giriş Yap',
          ),
        ],
      ),
    );
  }
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen gerekli alanları doldurun';
  }
  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
    return 'Lütfen geçerli bir email adresi giriniz';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen gerekli alanları doldurun';
  }
  if (!RegExp(r'^.{8,}$').hasMatch(value)) {
    return 'Şifre en az 8 karakter uzunluğunda olmalı';
  }
  return null;
}
