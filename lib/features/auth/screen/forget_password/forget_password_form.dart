import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/widgets/submit_button.dart';
import 'package:gurme/common/widgets/form_fields.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class ForgetPasswordForm extends ConsumerStatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends ConsumerState<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> sendResetEmail(
      BuildContext context, WidgetRef ref, String email) async {
    await ref
        .read(authControllerProvider.notifier)
        .sendResetEmail(context, email);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 30),
          SubmitButton(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await sendResetEmail(context, ref, emailController.text.trim());
              }
            },
            text: 'Sıfırlama Bağlantısını Gönder',
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
