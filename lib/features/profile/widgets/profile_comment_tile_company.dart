import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/common/widgets/comment_bottom_sheet.dart';
import 'package:gurme/common/widgets/comment_star_count.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';

class CommentTileCompany extends StatelessWidget {
  final Comment comment;
  final Item item;
  const CommentTileCompany(
      {super.key, required this.comment, required this.item});

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: GestureDetector(
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
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              showPopUpScreen(
                                context: context,
                                builder: (context) {
                                  return ItemScreen(
                                    item: item,
                                  );
                                },
                              );
                            },
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
                                  item.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text(
                                '${item.companyName} - ${item.name}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
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
                                    comment.text ?? "",
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
