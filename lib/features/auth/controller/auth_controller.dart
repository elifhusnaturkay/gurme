import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/repository/auth_repository.dart';
import 'package:gurme/models/user_model.dart';

final authControllerProvider = StateNotifierProvider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanged;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanged => _authRepository.authStateChanged;

  Future<void> signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> signOut(BuildContext context) async {
    final response = await _authRepository.signOut();

    response.fold((error) => showToast(context, error),
        (r) => _ref.read(userProvider.notifier).update((state) => null));
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    final user = await _authRepository.signInWithEmail(email, password);

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password, String name) async {
    final user = await _authRepository.signUpWithEmail(email, password, name);

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> signInAnonymously(BuildContext context) async {
    final user = await _authRepository.signInAnonymously();

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> sendResetEmail(BuildContext context, String email) async {
    final response = await _authRepository.sendResetEmail(email);

    response.fold(
      (error) => showToast(context, error),
      (r) => showToast(context, 'Sıfırlama bağlantısı gönderildi'),
    );
  }
}
