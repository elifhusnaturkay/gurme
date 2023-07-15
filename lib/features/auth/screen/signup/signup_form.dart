import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/widgets/submit_button.dart';
import 'package:gurme/common/widgets/form_fields.dart';
import 'package:gurme/features/auth/constants/auth_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUpWithEmail(BuildContext context, WidgetRef ref,
      String email, String password, String name) async {
    await ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(context, email, password, name);
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
              controller: nameController,
              hintText: AuthConstants.AdSoyad,
              validator: nameValidator,
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DefaultTextFormField(
              controller: emailController,
              hintText: AuthConstants.Email,
              validator: emailValidator,
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PasswordFormField(
              controller: passwordController,
              hintText: AuthConstants.Sifre,
              validator: passwordValidator,
            ),
          ),
          const SizedBox(height: 30),
          SubmitButton(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await signUpWithEmail(context, ref, emailController.text,
                    passwordController.text, nameController.text);
              }
            },
            text: AuthConstants.KayitOl,
          ),
        ],
      ),
    );
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return AuthConstants.GerekliAlanDoldur;
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return AuthConstants.GerekliAlanDoldur;
  }
  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
    return AuthConstants.GecerliEmailGir;
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return AuthConstants.GerekliAlanDoldur;
  }
  if (!RegExp(r'^.{8,}$').hasMatch(value)) {
    return AuthConstants.SifreEnAz8Karakter;
  }
  return null;
}
