import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/common/widgets/no_background_item_list_tile.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
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
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, 60),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Hero(
                      tag: "hometosearch",
                      child: AppBar(
                        automaticallyImplyLeading: true,
                        titleSpacing: 0,
                        iconTheme: const IconThemeData().copyWith(
                          color: ColorConstants.black,
                        ),
                        backgroundColor: Theme.of(context).canvasColor,
                        foregroundColor:
                            const Color.fromRGBO(246, 246, 246, 0.5),
                        elevation: 2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                        centerTitle: true,
                        title: GestureDetector(
                          onTap: () {
                            updateCategoryIndex(currentCategoryIndex);
                            filteredSearchCategoryBottomSheet(
                              context,
                              categories,
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
                                  color: ColorConstants.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.expand_more_rounded,
                                color: ColorConstants.black,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                ...List.generate(
                                  items.length,
                                  (index) {
                                    final item = items[index];
                                    return NoBackgroundItemListTile(
                                      item: item,
                                      length: items.length,
                                      index: index,
                                      isCompanyScreen: false,
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
                        color: ColorConstants.primaryColor,
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

  // can't seperate as a widget because of setState
  Future<dynamic> filteredSearchCategoryBottomSheet(
      BuildContext context, List<CategoryModel> categories) {
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
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return DraggableScrollableSheet(
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
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: const Icon(
                                  Icons.close,
                                ),
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
                                child: const Icon(
                                  Icons.done,
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
                            verticalDirection: VerticalDirection.down,
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
                                      updateCategoryIndex(
                                        index,
                                      );
                                      setState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: ref.watch(
                                                      selectedCategoryIndexProvider) ==
                                                  index
                                              ? 2
                                              : 1,
                                          color: ref.watch(
                                                      selectedCategoryIndexProvider) ==
                                                  index
                                              ? ColorConstants.primaryColor
                                                  .withOpacity(1)
                                              : ColorConstants.primaryColor
                                                  .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Text(
                                        categories[index].name,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstants.black,
                                        ),
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
            );
          },
        );
      },
    );
  }
}
