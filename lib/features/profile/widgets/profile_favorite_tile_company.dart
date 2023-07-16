import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/user_model.dart';

class FavoriteTileCompany extends StatefulWidget {
  final Company company;
  final WidgetRef ref;
  final UserModel user;
  const FavoriteTileCompany({
    super.key,
    required this.company,
    required this.ref,
    required this.user,
  });

  @override
  State<FavoriteTileCompany> createState() => _FavoriteTileCompanyState();
}

class _FavoriteTileCompanyState extends State<FavoriteTileCompany>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConstants.primaryColor.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.companyScreen,
                      pathParameters: {"id": widget.company.id},
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: Image.network(
                                widget.company.bannerPic,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.company.name,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.company.rating.toStringAsFixed(1),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey.shade400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.grade_rounded,
                                    size: 18,
                                    color: ColorConstants.starColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "(${widget.company.ratingCount})",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () async {
                            if (widget.ref
                                    .read(userProvider.notifier)
                                    .state!
                                    .uid ==
                                widget.user.uid) {
                              setState(() {
                                favorite = !favorite;
                              });
                              if (!favorite) {
                                await widget.ref
                                    .read(profileControllerProvider.notifier)
                                    .removeFromFavorites(
                                        widget.user, widget.company.id);
                              } else {
                                await widget.ref
                                    .read(profileControllerProvider.notifier)
                                    .addToFavorites(
                                        widget.user, widget.company.id);
                              }
                            }
                          },
                          icon: widget.ref
                                      .watch(userProvider.notifier)
                                      .state!
                                      .uid ==
                                  widget.user.uid
                              ? favorite
                                  ? Icon(
                                      Icons.favorite,
                                      color: ColorConstants.primaryColor,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: ColorConstants.primaryColor,
                                    )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
