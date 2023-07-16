import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/features/item/widgets/comment_field_screen.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';

class PopUpMenuButton extends StatelessWidget {
  const PopUpMenuButton({
    super.key,
    required this.ref,
    required this.item,
    required this.comment,
  });

  final WidgetRef ref;
  final Item item;
  final Comment comment;

  deleteComment(String commentId) {
    ref.read(itemControllerProvider.notifier).deleteComment(commentId);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == "Edit") {
          showPopUpScreen(
            context: context,
            builder: (context) {
              return CommentFieldScreen(
                ref: ref,
                item: item,
                currentUserComment: comment,
              );
            },
          );
        } else if (value == "Delete") {
          deleteComment(comment.id);
        }
      },
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: const Icon(Icons.more_vert_rounded),
      iconSize: 21,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "Edit",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yorumu Düzenle',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.edit_rounded,
                size: 20,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "Delete",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yorumu Sil',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.delete_rounded,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
