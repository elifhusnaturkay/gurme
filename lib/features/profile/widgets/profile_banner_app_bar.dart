import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/models/user_model.dart';

class ProfileBannerAppBar extends StatelessWidget {
  const ProfileBannerAppBar({
    super.key,
    required ScrollController scrollControllerNestedView,
    required this.screenWidth,
    required this.ref,
    required this.pageUserId,
    required this.user,
  }) : _scrollControllerNestedView = scrollControllerNestedView;

  final ScrollController _scrollControllerNestedView;
  final double screenWidth;
  final WidgetRef ref;
  final UserModel user;
  final String pageUserId;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      collapsedHeight: 60,
      toolbarHeight: 60,
      expandedHeight: 150,
      pinned: true,
      automaticallyImplyLeading: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // scroll offset to 0.0 - 1.0
          final double ratio =
              (_scrollControllerNestedView.offset / (150 - kToolbarHeight))
                  .clamp(0, 1);

          // sliverappbar color animation
          final backgroundColor = Color.lerp(
            const Color(0xFFCFD3ED).withOpacity(0.00),
            const Color(0xFFCFD3ED).withOpacity(1),
            ratio,
          );

          final textAlignment = AlignmentTween(
            begin: Alignment.center,
            end: Alignment.centerLeft,
          ).transform(ratio);

          // profile pic animation
          final imageRadius = 80 - (25 * ratio) + ((screenWidth - 393) * 0.1);
          final imagePositionBottom =
              (-55) - (25 * ratio) - ((screenWidth - 393) * 0.2);
          final imagePositionLeft =
              (screenWidth * 0.5 - 80) - ((screenWidth * 0.5 - 105) * ratio);
          final iconColor = Color.lerp(
            ColorConstants.black,
            Theme.of(context).canvasColor,
            ratio,
          );

          // icon animation
          final iconPositionBottom = 50 - (45 * ratio);
          final iconPositionLeft =
              (screenWidth * 0.5 + 40) + ((screenWidth * 0.4 - 50) * ratio);

          // name animation
          final namePositionLeft = (((screenWidth - 393) * 0.2 + 147) * ratio);
          final namePositionTop = 220 -
              ((150 + ((screenWidth - 393) * 0.2)) * ratio) +
              ((screenWidth - 393) * 0.2);

          // font size
          final fontSize = 32 + ((screenWidth - 393) * 0.1) - (10 * ratio);

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.network(
                  user.bannerPic,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: backgroundColor,
                ),
              ),
              Positioned(
                top: namePositionTop,
                left: namePositionLeft,
                right: 0,
                child: Align(
                  alignment: textAlignment,
                  child: SafeArea(
                    child: SizedBox(
                      child: Text(
                        user.name,
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: GoogleFonts.inter(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: imagePositionBottom,
                left: imagePositionLeft,
                child: Hero(
                  tag: "profiletoedit",
                  child: Container(
                    height: imageRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFCFD3ED),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: ColorConstants.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: imageRadius,
                      backgroundColor:
                          ColorConstants.primaryColor.withOpacity(0.2),
                      backgroundImage: NetworkImage(
                        user.profilePic,
                      ),
                    ),
                  ),
                ),
              ),
              ref.watch(userProvider.notifier).state!.uid == pageUserId
                  ? Positioned(
                      bottom: iconPositionBottom,
                      left: iconPositionLeft,
                      child: Container(
                        width: 50 + ((screenWidth - 393) * 0.1),
                        height: 50 + ((screenWidth - 393) * 0.1),
                        decoration: BoxDecoration(
                          color: ColorConstants.white.withOpacity(1 - ratio),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: ColorConstants.black
                                  .withOpacity(0.25 - 0.25 * ratio),
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.pushNamed(RouteConstants.editProfileScreen);
                          },
                          iconSize: 30 + ((screenWidth - 393) * 0.1),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: iconColor,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
