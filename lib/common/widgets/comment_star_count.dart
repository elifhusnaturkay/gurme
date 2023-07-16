import 'package:flutter/material.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/models/comment_model.dart';

class CommentStarCount extends StatelessWidget {
  const CommentStarCount({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        comment.rating,
        (index) => const Icon(
          Icons.grade_rounded,
          color: ColorConstants.starColor,
          size: 15,
        ),
      ),
    );
  }
}
