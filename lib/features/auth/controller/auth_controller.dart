import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/repository/auth_repository.dart';
import 'package:gurme/models/user_model.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthController {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signOutWithGoogle(BuildContext context) async {
    final response = await _authRepository.signOutWithGoogle();

    response.fold((error) => showToast(context, error),
        (r) => _ref.read(userProvider.notifier).update((state) => null));
  }
}
