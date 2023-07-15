import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';

class CommentFieldScreen extends StatefulWidget {
  final WidgetRef ref;
  final Item item;
  final Comment? currentUserComment;
  const CommentFieldScreen({
    super.key,
    required this.ref,
    required this.item,
    required this.currentUserComment,
  });

  @override
  State<CommentFieldScreen> createState() => _CommentFieldScreenState();
}

class _CommentFieldScreenState extends State<CommentFieldScreen> {
  late TextEditingController commentController;
  int ratingCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.currentUserComment != null) {
      commentController =
          TextEditingController(text: widget.currentUserComment!.text ?? '');
      ratingCount = widget.currentUserComment!.rating;
    } else {
      commentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> sendComment() async {
    await widget.ref.read(itemControllerProvider.notifier).sendComment(
          widget.ref.read(userProvider.notifier).state!,
          widget.item,
          ratingCount,
          commentController.text.trim(),
        );
  }

  Future<void> updateComment() async {
    await widget.ref.read(itemControllerProvider.notifier).updateComment(
          widget.currentUserComment!,
          widget.ref.read(userProvider.notifier).state!,
          widget.item,
          ratingCount,
          commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180 +
          ((MediaQuery.of(context).size.height - 760) * 0.1) +
          MediaQuery.of(context).viewInsets.bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          RatingBar.builder(
            glow: false,
            initialRating: ratingCount.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            unratedColor: Colors.grey.shade300,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.grade_rounded,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                ratingCount = rating.toInt();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              onChanged: (text) {},
              controller: commentController,
              cursorColor: Colors.indigo.shade400,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(
                  maxWidth: 120,
                  maxHeight: 60,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    onPressed: (ratingCount > 0 && ratingCount <= 5)
                        ? () async {
                            context.pop();
                            if (widget.currentUserComment == null) {
                              sendComment();
                            } else {
                              updateComment();
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade400,
                      shape: const StadiumBorder(),
                    ),
                    icon: Icon(
                      Icons.send_rounded,
                      color: (ratingCount > 0 && ratingCount <= 5)
                          ? Colors.indigo.shade400
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo.shade400,
                    width: 2,
                  ),
                ),
                border: const OutlineInputBorder(),
                hintText: 'Gurmenin yorum zamanı! (İsteğe Bağlı)',
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
