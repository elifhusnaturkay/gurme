import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/core/providers/global_keys.dart';

class FilteredSearchScreen extends ConsumerStatefulWidget {
  const FilteredSearchScreen({super.key});

  @override
  ConsumerState<FilteredSearchScreen> createState() =>
      _FilteredSearchScreenState();
}

class _FilteredSearchScreenState extends ConsumerState<FilteredSearchScreen> {
  final List<String> items = const [
    'Electronics',
    'Clothing',
    'Books',
    'Home Decor',
    'Sports',
    'Beauty',
    'Automotive',
    'Toys',
    'Food',
    'Health',
    'Garden',
    'Movies',
    'Music',
    'Pets',
    'Jewelry',
    'Furniture',
    'Fitness',
    'Travel',
    'Art',
    'Baby',
    'Office Supplies',
    'Crafts',
    'Outdoor',
    'Tools',
    'Fashion',
    'Shoes',
    'Accessories',
    'Electrical',
    'Appliances',
    'Gifts',
    'Grocery',
    'Stationery',
    'Electronics',
    'Clothing',
    'Books',
    'Home Decor',
    'Sports',
    'Beauty',
    'Automotive',
    'Toys',
    'Food',
    'Health',
    'Garden',
    'Movies',
    'Music',
    'Pets',
    'Jewelry',
    'Furniture',
    'Fitness',
    'Travel',
    'Art',
    'Baby',
    'Office Supplies',
    'Crafts',
    'Outdoor',
    'Tools',
    'Fashion',
    'Shoes',
    'Accessories',
    'Electrical',
    'Appliances',
    'Gifts',
    'Grocery',
    'Stationery',
  ];

  ValueKey<int>? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = const ValueKey<int>(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.indigo.shade400,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
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
                return DraggableScrollableSheet(
                  expand: false,
                  maxChildSize: 1,
                  minChildSize: 0.5,
                  initialChildSize: 0.5,
                  builder: (context, scrollController) => Column(
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
                              onTap: () {}, // TODO : Fetch
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
                                    items.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          key: ValueKey(index),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              width: selectedCategory ==
                                                      ValueKey<int>(index)
                                                  ? 3
                                                  : 1,
                                              color: Colors.indigo.shade400
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.food_bank),
                                              const SizedBox(width: 5),
                                              Text(
                                                items[index],
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
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
                "Kategori Adı",
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
      body: Column(
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
                          /*  showPopUpScreen(
                        context: context,
                        builder: (context) {
                          return ItemScreen(
                            item: item,
                          );
                        },
                      ); */
                        },
                        title: Column(
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      AssetConstants
                                          .defaultBannerPic, // TODO : Picture
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item, // TODO : Name
                                      style: GoogleFonts.inter(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item, // TODO : Company Name
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item, // TODO : Rating
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.grade_rounded,
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item, // TODO : Rating Count
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey.shade400,
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
                                          item, // TODO : Comment Count
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.chat_rounded,
                                          color: Colors.indigo.shade400,
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
                              margin: const EdgeInsets.fromLTRB(80, 0, 20, 0),
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: Colors.grey.shade300,
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
