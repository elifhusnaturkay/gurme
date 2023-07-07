import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/item/controller/item_controller.dart';
import 'package:gurme/models/item_model.dart';

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
              SingleChildScrollView(
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
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
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
                  ],
                ),
              ),
              ref.watch(getCommentsProvider(widget._item.id)).when(
                    data: (comments) {
                      return Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Colors.indigo.shade400.withOpacity(0.2),
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        foregroundImage: NetworkImage(
                                          comments[index].user.profilePic,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        comments[index].user.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(error.toString());
                    },
                    loading: () => const LoadingSpinner(
                      height: 50,
                      width: 50,
                    ),
                  )
            ],
          );
        },
      ),
    );
  }
}
