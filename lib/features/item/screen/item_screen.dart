import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/features/item/widgets/item_card.dart';
import 'package:gurme/features/item/widgets/item_comment_tile.dart';
import 'package:gurme/features/item/widgets/zero_comment_tile_item.dart';
import 'package:gurme/features/notfound/not_found_screen.dart';
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

                  Comment? currentUserComment;

                  if (comments.isNotEmpty && userId == comments.first.userRef) {
                    currentUserComment = comments.first;
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
                                  return ItemCommentTile(
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
                error: (error, stackTrace) =>
                    const NotFoundScreen(isNotFound: false),
                loading: () => Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: ColorConstants.primaryColor,
                    size: 50,
                  ),
                ),
              );
        },
      ),
    );
  }
}
