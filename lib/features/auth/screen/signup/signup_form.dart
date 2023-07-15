import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/lose_focus.dart';
import 'package:gurme/common/widgets/submit_button.dart';
import 'package:gurme/common/widgets/form_fields.dart';
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

  Future<void> signUpWithEmail(
      WidgetRef ref, String email, String password, String name) async {
    await ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(email, password, name);
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
              hintText: 'Ad Soyad',
              validator: nameValidator,
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DefaultTextFormField(
              controller: emailController,
              hintText: 'Email',
              validator: emailValidator,
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PasswordFormField(
              controller: passwordController,
              hintText: 'Şifre',
              validator: passwordValidator,
            ),
          ),
          const SizedBox(height: 30),
          SubmitButton(
            onTap: () async {
              loseFocus();
              if (_formKey.currentState!.validate()) {
                while (GoRouter.of(context).location !=
                    '/${RouteConstants.homeScreen}') {
                  context.pop();
                }
                await signUpWithEmail(ref, emailController.text,
                    passwordController.text, nameController.text);
              }
            },
            text: 'Kayıt Ol',
          ),
        ],
      ),
    );
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen gerekli alanları doldurun';
  }
  return null;
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
    return 'Password must be at least 8 character';
  }
  return null;
}
