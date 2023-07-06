import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/splash/controller/splash_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPositionAsyncValue = ref.watch(getPositionProvider);

    return getPositionAsyncValue.when(
      data: (position) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (position != null) {
              final location = GeoPoint(position.latitude, position.longitude);
              _updateLocationData(ref, location);
            }
            context.goNamed(RouteConstants.homeScreen);
          },
        );
        return _buildLoadingContainer(context);
      },
      error: (error, stackTrace) => const Text('Error'),
      loading: () => _buildLoadingContainer(context),
    );
  }

  Widget _buildLoadingContainer(BuildContext context) {
    return Container(
      color: Colors.indigo.shade400,
      child: Center(
        child: Image.asset(
          AssetConstants.longLogoWhite,
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }

  void _updateLocationData(WidgetRef ref, GeoPoint location) {
    final userModel = ref.read(userProvider);
    if (userModel != null) {
      final updatedUserModel = userModel.copyWith(
        currentLocation: location,
        comments: [],
      );
      ref.read(userProvider.notifier).update((state) => updatedUserModel);
    }
  }
}
