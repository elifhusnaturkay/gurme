import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void signInWithGoogle() async {
    final user = await _authRepository.signInWithGoogle();

    user.fold(
        (l) => null,
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }
}
