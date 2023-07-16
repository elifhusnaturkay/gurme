import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/company/controller/company_controller.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/user_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CompanyBannerSliverAppBar extends StatefulWidget {
  const CompanyBannerSliverAppBar({
    super.key,
    required AutoScrollController autoScrollController,
    required this.user,
    required this.company,
    required this.ref,
  }) : _autoScrollController = autoScrollController;

  final Company company;
  final AutoScrollController _autoScrollController;
  final UserModel user;
  final WidgetRef ref;

  @override
  State<CompanyBannerSliverAppBar> createState() =>
      _CompanyBannerSliverAppBarState();
}

class _CompanyBannerSliverAppBarState extends State<CompanyBannerSliverAppBar> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.ref
        .read(userProvider.notifier)
        .state!
        .favoriteCompanyIds
        .contains(widget.company.id);
  }

  Future<void> removeFromFavorites(UserModel user) async {
    await widget.ref
        .read(
          profileControllerProvider.notifier,
        )
        .removeFromFavorites(
          user,
          widget.company.id,
        );
  }

  Future<void> addToFavorites(UserModel user) async {
    await widget.ref
        .read(
          profileControllerProvider.notifier,
        )
        .addToFavorites(
          user,
          widget.company.id,
        );
  }

  Future<bool> isFavoriteCompany(String userId, String companyId) async {
    return await widget.ref
        .read(companyControllerProvider.notifier)
        .isFavoriteCompany(userId, companyId);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double ratio =
              (widget._autoScrollController.offset / (150 - kToolbarHeight))
                  .clamp(0, 1);
          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  widget.company.bannerPic,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 28,
                right: 0,
                child: widget.user.isAuthenticated
                    ? IconButton(
                        onPressed: () {
                          isFavorite
                              ? removeFromFavorites(widget.user)
                              : addToFavorites(widget.user);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: ColorConstants.primaryColor
                              .withOpacity(1 - ratio),
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    return await LocationUtils.showOnMap(
                        context, widget.company.location);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorConstants.secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      4,
                      4,
                      4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Haritada Göster",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.near_me_rounded,
                          size: 20,
                          color: ColorConstants.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
