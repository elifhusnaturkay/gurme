import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';

class ItemScreenItemCard extends StatelessWidget {
  const ItemScreenItemCard({
    super.key,
    required this.scrollPosition,
    required this.item,
    required this.scrollController,
    required this.ref,
    required this.currentUserComment,
    required this.commentCount,
  });

  final WidgetRef ref;
  final ValueNotifier<double> scrollPosition;
  final Item item;
  final ScrollController scrollController;
  final Comment? currentUserComment;
  final int commentCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: scrollPosition,
            child: const Icon(Icons.maximize_rounded),
            builder: (context, value, child) {
              IconData currentIcon = value > 0.6
                  ? Icons.expand_more_rounded
                  : Icons.expand_less_rounded;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  size: 48,
                  currentIcon,
                  key: ValueKey<IconData>(currentIcon),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:
                      140 + ((MediaQuery.of(context).size.width - 393) * 0.1),
                  height:
                      160 + ((MediaQuery.of(context).size.height - 760) * 0.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConstants.primaryColor.withOpacity(0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.picture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 10, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 22 +
                                ((MediaQuery.of(context).size.width - 393) *
                                    0.1),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () => context.pushNamed(
                            RouteConstants.companyScreen,
                            pathParameters: {"id": item.companyId},
                          ),
                          child: Text(
                            item.companyName,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${item.price} ₺",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            RatingBarIndicator(
                              rating: item.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: ColorConstants.starColor,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              unratedColor: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "(${item.ratingCount})",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        commentCount.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Yorum",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 5),
                  child: TextButton(
                    onPressed: () {
                      showCommentFieldBottomSheet(
                        context,
                        ref,
                        item,
                        currentUserComment,
                      );
                    },
                    child: currentUserComment == null &&
                            ref
                                .watch(userProvider.notifier)
                                .state!
                                .isAuthenticated
                        ? Text(
                            "Kendi Yorumunu Bırak",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.primaryColor,
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
