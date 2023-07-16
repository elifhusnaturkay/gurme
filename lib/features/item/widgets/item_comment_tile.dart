import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/common/widgets/comment_bottom_sheet.dart';
import 'package:gurme/common/widgets/comment_star_count.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/widgets/pop_up_menu_buton.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';

class ItemCommentTile extends StatelessWidget {
  const ItemCommentTile({
    super.key,
    required this.comment,
    required this.ref,
    required this.item,
  });

  final Item item;
  final WidgetRef ref;
  final Comment comment;
  @override
  Widget build(BuildContext context) {
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
              child: ListTile(
                onTap: () {
                  showPopUpScreen(
                    context: context,
                    builder: (context) {
                      return CommentBottomSheet(
                        comment: comment,
                      );
                    },
                  );
                },
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.profileScreen,
                              pathParameters: {"id": comment.user.uid},
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                ColorConstants.primaryColor.withOpacity(0.2),
                            radius: 24,
                            backgroundImage: NetworkImage(
                              comment.user.profilePic,
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
                              comment.user.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CommentStarCount(comment: comment),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                ),
                                child: SizedBox(
                                  child: Text(
                                    comment.text ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      ref.watch(userProvider.notifier).state!.uid ==
                              comment.user.uid
                          ? PopUpMenuButton(
                              ref: ref,
                              item: item,
                              comment: comment,
                            )
                          : Container(),
                    ],
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
