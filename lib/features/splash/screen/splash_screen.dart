import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/core/providers/global_providers.dart';
import 'package:gurme/features/notfound/not_found_screen.dart';
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
      error: (error, stackTrace) => const NotFoundScreen(isNotFound: false),
      loading: () => _buildLoadingContainer(context),
    );
  }

  Widget _buildLoadingContainer(BuildContext context) {
    return Container(
      color: ColorConstants.primaryColor,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: const Center(
          child: LoadingSpinner(width: 75, height: 75),
        ),
      ),
    );
  }

  void _updateLocationData(WidgetRef ref, GeoPoint location) {
    ref.read(locationProvider.notifier).update((state) => location);
  }
}
