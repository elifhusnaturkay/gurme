import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gurme/features/splash/repository/splash_repository.dart';

final splashControllerProvider =
    StateNotifierProvider<SplashController, bool>((ref) {
  return SplashController(
    splashRepository: ref.watch(splashRepositoryProvider),
  );
});

final getPositionProvider = FutureProvider.autoDispose((ref) async {
  final permission =
      await ref.watch(splashControllerProvider.notifier).askPermission();

  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    return await ref.watch(splashControllerProvider.notifier).getLocation();
  } else {
    return null;
  }
});

class SplashController extends StateNotifier<bool> {
  final SplashRepository _splashRepository;

  SplashController({required SplashRepository splashRepository})
      : _splashRepository = splashRepository,
        super(false);

  Future<LocationPermission> askPermission() async {
    return await _splashRepository.askPermission();
  }

  Future<Position> getLocation() async {
    return await _splashRepository.getLocation();
  }
}
