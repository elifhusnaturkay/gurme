import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/repository/auth_repository.dart';
import 'package:gurme/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  if (!ref.watch(authControllerProvider)) {
    return authController.authStateChanged;
  }
  return const Stream.empty();
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
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> signOut(BuildContext context) async {
    state = true;
    final response = await _authRepository.signOut();

    state = false;
    response.fold((error) => showToast(context, error), (r) {
      _ref.read(authControllerProvider.notifier).signInAnonymously(context);
    });
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signInWithEmail(email, password);
    state = false;
    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password, String name) async {
    final user = await _authRepository.signUpWithEmail(email, password, name);

    user.fold((error) {
      showToast(context, error);
    }, (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      showToast(context, 'Kayıt olma işlemi başarılı');
    });
  }

  Future<void> signInAnonymously(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAnonymously();

    user.fold(
        (error) => showToast(context, error),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
    state = false;
  }

  Future<void> sendResetEmail(BuildContext context, String email) async {
    final response = await _authRepository.sendResetEmail(email);

    response.fold(
      (error) => showToast(context, error),
      (r) => showToast(context, 'Sıfırlama bağlantısı gönderildi'),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
