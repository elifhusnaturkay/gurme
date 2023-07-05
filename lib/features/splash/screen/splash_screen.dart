import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/splash/controller/splash_controller.dart';
import 'package:gurme/models/user_model.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
  }

  void updateLocationData(GeoPoint location) {
    userModel = ref.read(userProvider.notifier).state;
    userModel = userModel?.copyWith(
      name: userModel!.name,
      profilePic: userModel!.profilePic,
      uid: userModel!.uid,
      isAuthenticated: userModel!.isAuthenticated,
      currentLocation: location,
      comments: [],
    );

    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getPositionProvider).when(
          data: (position) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (position != null) {
                final location =
                    GeoPoint(position.latitude, position.longitude);
                updateLocationData(location);
              }
            });
            return Container(
              color: Colors.indigo.shade400,
              child: Center(
                child: Image.asset(
                  AssetConstants.longLogoWhite,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              ),
            );
          },
          error: (error, stackTrace) => const Text("error"),
          loading: () {
            return Container(
              color: Colors.indigo.shade400,
              child: Center(
                child: Image.asset(
                  AssetConstants.longLogoWhite,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              ),
            );
          },
        );
  }
}
