import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/widgets/no_background_item_list_tile.dart';
import 'package:gurme/features/company/controller/company_controller.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CompanyListField extends StatelessWidget {
  const CompanyListField(
      {super.key,
      required this.itemsKeys,
      required AutoScrollController autoScrollController,
      required this.companyData})
      : _autoScrollController = autoScrollController;

  final Map<int, dynamic> itemsKeys;
  final AutoScrollController _autoScrollController;
  final CompanyData companyData;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          companyData.categories.length,
          (categoryIndex) {
            itemsKeys[categoryIndex] = RectGetter.createGlobalKey();
            return RectGetter(
              key: itemsKeys[categoryIndex],
              child: AutoScrollTag(
                key: ValueKey(categoryIndex),
                index: categoryIndex,
                controller: _autoScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                      child: Text(
                        companyData.categories[categoryIndex].name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ...List.generate(
                          companyData.items[categoryIndex].length,
                          (index) {
                            final item =
                                companyData.items[categoryIndex][index];
                            return NoBackgroundItemListTile(
                              item: item,
                              length: companyData.items[categoryIndex].length,
                              index: index,
                              isCompanyScreen: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
