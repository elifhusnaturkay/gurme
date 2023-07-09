import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
          return Column(
            children: [
              ItemScreenItemCard(
                scrollPosition: scrollPosition,
                widget: widget,
                scrollController: scrollController,
              ),
              ref.watch(getCommentsProvider(widget._item.id)).when(
                    data: (comments) {
                      return Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            if (comments[index].text == null ||
                                comments[index].text!.isEmpty) {
                              return Container();
                            }

                            return CommentTile(
                              comment: comments[index],
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(error.toString());
                    },
                    loading: () => LoadingAnimationWidget.waveDots(
                      color: Colors.indigo.shade400,
                      size: 50,
                    ),
                  )
            ],
          );
        },
      ),
    );
  }
}

class ItemScreenItemCard extends StatelessWidget {
  const ItemScreenItemCard(
      {super.key,
      required this.scrollPosition,
      required this.widget,
      required this.scrollController});

  final ValueNotifier<double> scrollPosition;
  final ItemScreen widget;
  final ScrollController scrollController;

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
                  grade: 200,
                  opticalSize: 48,
                  weight: 700,
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
                  width: 140,
                  height: 160,
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
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          widget._item.companyName,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
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
                          return const CommentFieldScreen();
                        },
                      );
                    },
                    child: Text(
                      "Kendi Yorumunu Bırak",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade400,
                      ),
                    ),
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
  const CommentTile({super.key, required this.comment});

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                              print("object");
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

class CommentFieldScreen extends StatelessWidget {
  const CommentFieldScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int _ratingCount = 0;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          RatingBar.builder(
            glow: false,
            initialRating: 0,
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
              _ratingCount = rating.toInt();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              cursorColor: Colors.indigo.shade400,
              maxLines: 3,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Gurmenin yorum zamanı!',
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // TODO: Collection Kaydı
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade400,
              shape: const StadiumBorder(),
            ),
            child: Text(
              "Gönder",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).canvasColor,
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
