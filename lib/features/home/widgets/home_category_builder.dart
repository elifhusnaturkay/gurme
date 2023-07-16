import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/search/controller/search_controller.dart';
import 'package:gurme/models/category_model.dart';

class HomeCategoryBuilder extends StatelessWidget {
  const HomeCategoryBuilder(
      {super.key, required this.ref, required this.category});

  final WidgetRef ref;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                ref
                    .read(selectedCategoryProvider.notifier)
                    .update((state) => category.id);
                context.pushNamed(
                  RouteConstants.filteredSearchScreen,
                );
              },
              child: CategoryImage(category: category),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 100,
              height: 40,
              child: Text(
                category.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryImage extends StatefulWidget {
  const CategoryImage({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  State<CategoryImage> createState() => _CategoryImageState();
}

class _CategoryImageState extends State<CategoryImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 75,
      width: 75,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(92, 107, 192, 0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: Image.network(
          widget.category.picture,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
