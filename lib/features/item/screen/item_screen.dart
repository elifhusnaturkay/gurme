import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/show_pop_up.dart';
import 'package:gurme/common/widgets/comment_bottom_sheet.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/features/item/widgets/comment_field_screen.dart';
import 'package:gurme/features/item/widgets/item_card.dart';
import 'package:gurme/features/item/widgets/zero_comment_tile_item.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ItemScreen extends ConsumerStatefulWidget {
  final Item _item;
  const ItemScreen({
    super.key,
    required Item item,
  }) : _item = item;

  @override
  ConsumerState<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends ConsumerState<ItemScreen>
    with TickerProviderStateMixin {
  late DraggableScrollableController _draggableScrollableController;
  late ValueNotifier<double> scrollPosition;

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController();
    scrollPosition = ValueNotifier<double>(0.0);
  }

  bool animateIcon(DraggableScrollableNotification notification) {
    scrollPosition.value = _draggableScrollableController.pixels /
        MediaQuery.of(context).size.height;
    return false;
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    scrollPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: animateIcon,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1,
        minChildSize: 0.5,
        expand: false,
        controller: _draggableScrollableController,
        builder: (BuildContext context, ScrollController scrollController) {
          return ref.watch(getCommentsProvider(widget._item.id)).when(
                data: (comments) {
                  String userId = ref.watch(userProvider.notifier).state!.uid;
                  int currentUserCommentIndex = comments
                      .indexWhere((comment) => comment.user.uid == userId);

                  Comment? currentUserComment;
                  // if current user have a comment it swaps the comment to beginning of list
                  if (currentUserCommentIndex != -1) {
                    currentUserComment =
                        comments.removeAt(currentUserCommentIndex);
                    comments.insert(0, currentUserComment);
                  }
                  return Column(
                    children: [
                      ItemScreenItemCard(
                        scrollPosition: scrollPosition,
                        item: widget._item,
                        scrollController: scrollController,
                        ref: ref,
                        currentUserComment: currentUserComment,
                        commentCount: comments.length,
                      ),
                      comments.isEmpty
                          ? Expanded(
                              child: ListView(
                                controller: scrollController,
                                shrinkWrap: true,
                                children: const [
                                  ZeroCommentTileItem(),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return CommentTile(
                                    comment: comments[index],
                                    ref: ref,
                                    item: widget._item,
                                  );
                                },
                              ),
                            )
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return Text(error.toString());
                },
                loading: () => Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: Colors.indigo.shade400,
                    size: 50,
                  ),
                ),
              );
        },
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.ref,
    required this.item,
  });

  deleteComment(String commentId) {
    ref.read(itemControllerProvider.notifier).deleteComment(commentId);
  }

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
                color: Colors.indigo.shade400.withOpacity(0.06),
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
                                Colors.indigo.shade400.withOpacity(0.2),
                            radius: 24,
                            backgroundImage: NetworkImage(
                              comment.user.profilePic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.68,
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                comment.rating,
                                (index) => const Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                              ),
                            ),
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
                      Expanded(
                        child: ref.watch(userProvider.notifier).state!.uid ==
                                comment.user.uid
                            ? PopupMenuButton(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                              )
                            : Container(),
                      ),
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
