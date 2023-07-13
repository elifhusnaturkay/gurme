import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future<dynamic> showPopUpScreen({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    enableDrag: true,
    useSafeArea: true,
    builder: builder,
  );
}

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
                        widget: widget,
                        scrollController: scrollController,
                        ref: ref,
                        currentUserComment: currentUserComment,
                      ),
                      comments.isEmpty
                          ? Expanded(
                              child: ListView(
                                children: const [
                                  ZeroCommentTile(),
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

class ItemScreenItemCard extends StatelessWidget {
  const ItemScreenItemCard({
    super.key,
    required this.scrollPosition,
    required this.widget,
    required this.scrollController,
    required this.ref,
    required this.currentUserComment,
  });

  final WidgetRef ref;
  final ValueNotifier<double> scrollPosition;
  final ItemScreen widget;
  final ScrollController scrollController;
  final Comment? currentUserComment;

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
                    color: Colors.indigo.shade400.withOpacity(0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget._item.picture,
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
                          widget._item.name,
                          style: GoogleFonts.inter(
                            fontSize: 28 +
                                ((MediaQuery.of(context).size.width - 393) *
                                    0.1),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () => context.pushNamed(
                            RouteConstants.companyScreen,
                            pathParameters: {"id": widget._item.companyId},
                          ),
                          child: Text(
                            widget._item.companyName,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
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
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 5),
                  child: Text(
                    "Yorumlar",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 5),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).canvasColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20, 17),
                            topRight: Radius.elliptical(20, 17),
                          ),
                        ),
                        enableDrag: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: FocusScope(
                              child: CommentFieldScreen(
                                ref: ref,
                                item: widget._item,
                                currentUserComment: currentUserComment,
                              ),
                            ),
                          );
                        },
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
                              color: Colors.indigo.shade400,
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

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.ref});

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
                            backgroundColor: Colors.transparent,
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
                                    comment.text!, // cant be null
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
                                onSelected: (value) {},
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
                                  PopupMenuItem<int>(
                                    value: 0,
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
                                  PopupMenuItem<int>(
                                    value: 1,
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

class ZeroCommentTile extends StatelessWidget {
  const ZeroCommentTile({super.key});

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: ListTile(
                  minVerticalPadding: 0,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 24,
                          child: Image.asset(
                            AssetConstants.shortLogoPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gurme",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                              5,
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
                                  "Hiç yorum yok! İlk gurme sen ol!",
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
        ],
      ),
    );
  }
}

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
          TextEditingController(text: widget.currentUserComment!.text);
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
                              await widget.ref
                                  .read(itemControllerProvider.notifier)
                                  .sendComment(
                                    widget.ref
                                        .read(userProvider.notifier)
                                        .state!,
                                    widget.item,
                                    ratingCount,
                                    commentController.text.trim(),
                                  );
                            } else {
                              await widget.ref
                                  .read(itemControllerProvider.notifier)
                                  .updateComment(
                                    widget.currentUserComment!,
                                    widget.ref
                                        .read(userProvider.notifier)
                                        .state!,
                                    widget.item,
                                    ratingCount,
                                    commentController.text.trim(),
                                  );
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

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ListTile(
                minVerticalPadding: 0,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 28,
                        backgroundImage: NetworkImage(
                          comment.user.profilePic,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
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
                          mainAxisSize: MainAxisSize.max,
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
                                comment.text!, // cant be null
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
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
        ],
      ),
    );
  }
}
