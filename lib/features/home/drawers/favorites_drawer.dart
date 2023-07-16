import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/widgets/no_background_company_list_tile.dart';
import 'package:gurme/core/providers/global_providers.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
import 'package:gurme/features/home/drawers/widgets/anon_favorite_drawer_warning.dart';
import 'package:gurme/features/home/drawers/widgets/favorites_text.dart';
import 'package:gurme/features/home/drawers/widgets/user_favorite_drawer_warning.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoritesDrawer extends ConsumerStatefulWidget {
  const FavoritesDrawer({super.key});

  @override
  ConsumerState<FavoritesDrawer> createState() => _FavoritesDrawerState();
}

class _FavoritesDrawerState extends ConsumerState<FavoritesDrawer> {
  @override
  Widget build(BuildContext context) {
    GeoPoint? userLocation;
    if (ref.watch(locationProvider.notifier).state != null) {
      userLocation = GeoPoint(
          ref.watch(locationProvider.notifier).state!.latitude,
          ref.watch(locationProvider.notifier).state!.longitude);
    }
    return Drawer(
      width: 350,
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: ref.watch(userProvider.notifier).state!.isAuthenticated
                ? const FavoritesText()
                : const AnonFavoriteDrawerWarning(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: ref
                  .watch(
                    getFavoriteCompaniesProvider(ref
                        .watch(userProvider.notifier)
                        .state!
                        .favoriteCompanyIds),
                  )
                  .when(
                    data: (companies) {
                      return companies.isEmpty &&
                              ref
                                  .watch(userProvider.notifier)
                                  .state!
                                  .isAuthenticated
                          ? [const UserFavoritesDrawerWarning()]
                          : List.generate(
                              companies.length,
                              (index) {
                                final company = companies[index];
                                return NoBackgroundCompanyListTile(
                                  company: company,
                                  userLocation: userLocation,
                                  index: index,
                                  length: companies.length,
                                );
                              },
                            );
                    },
                    error: (error, stackTrace) => [const Text("error")],
                    loading: () => [
                      Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: ColorConstants.primaryColor,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
