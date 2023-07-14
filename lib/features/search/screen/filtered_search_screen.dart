import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/features/search/controller/search_controller.dart';
import 'package:gurme/models/category_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FilteredSearchScreen extends ConsumerStatefulWidget {
  const FilteredSearchScreen({super.key});

  @override
  ConsumerState<FilteredSearchScreen> createState() =>
      _FilteredSearchScreenState();
}

class _FilteredSearchScreenState extends ConsumerState<FilteredSearchScreen> {
  updateCategoryIndex(int index) {
    ref.read(selectedCategoryIndexProvider.notifier).update((state) => index);
  }

  updateSelectedCategory(List<CategoryModel> categories) {
    final selectedCategoryIndex =
        ref.read(selectedCategoryIndexProvider.notifier).state;
    ref
        .read(selectedCategoryProvider.notifier)
        .update((state) => categories[selectedCategoryIndex].id);
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategoryId =
        ref.watch(selectedCategoryProvider.notifier).state!;

    return ref.watch(getCategoriesProvider).when(
          data: (categories) {
            final currentCategoryIndex = categories
                .indexWhere((category) => category.id == selectedCategoryId);

            final CategoryModel selectedCategory;
            if (currentCategoryIndex != -1) {
              selectedCategory = categories[currentCategoryIndex];
            } else {
              selectedCategory = categories[0];
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 3,
                backgroundColor: Colors.indigo.shade400,
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    updateCategoryIndex(currentCategoryIndex);
                    showModalBottomSheet(
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
                      builder: (context) {
                        return Consumer(
                          builder: (context, ref, child) =>
                              DraggableScrollableSheet(
                            expand: false,
                            maxChildSize: 1,
                            minChildSize: 0.3,
                            initialChildSize: 0.5,
                            builder: (context, scrollController) => Column(
                              children: [
                                SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  controller: scrollController,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: const Icon(Icons.close),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Bir Kategori Seç",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                updateSelectedCategory(
                                                  categories,
                                                );
                                                setState(() {});
                                                context.pop();
                                              },
                                              child: Text(
                                                "Kaydet",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    controller: scrollController,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          spacing: 5,
                                          alignment: WrapAlignment.start,
                                          runSpacing: 10,
                                          runAlignment: WrapAlignment.start,
                                          children: [
                                            ...List.generate(
                                              categories.length,
                                              (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    updateCategoryIndex(index);
                                                    setState(() {});
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: ref.watch(
                                                                    selectedCategoryIndexProvider) ==
                                                                index
                                                            ? 3
                                                            : 1,
                                                        color: Colors
                                                            .indigo.shade400
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                            Icons.food_bank),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          categories[index]
                                                              .name,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.expand_more_rounded,
                        color: Colors.transparent,
                        size: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        selectedCategory.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.expand_more_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              body: ref
                  .watch(getItemsByCategoryProvider(selectedCategory.id))
                  .when(
                    data: (items) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                const SizedBox(height: 5),
                                ...List.generate(
                                  items.length,
                                  (index) {
                                    final item = items[index];
                                    return Column(
                                      children: [
                                        ListTile(
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
                                          title: Column(
                                            children: [
                                              const SizedBox(height: 5),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        item.picture,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.name,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        item.companyName,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            item.rating
                                                                .toStringAsFixed(
                                                                    1),
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Icon(
                                                            Icons.grade_rounded,
                                                            size: 18,
                                                            color: Colors.amber,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            item.ratingCount
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            item.commentCount
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons.chat_rounded,
                                                            color: Colors.indigo
                                                                .shade400,
                                                            size: 12,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        index != items.length - 1
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        80, 0, 20, 0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                                color: Colors.grey.shade300,
                                              )
                                            : const SizedBox(),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                  ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Scaffold(
            body: Center(
              child: LoadingSpinner(
                height: 75,
                width: 75,
              ),
            ),
          ),
        );
  }
}
