import 'package:flutter/material.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/models/category_model.dart';

class CompanySliverTabBar extends StatelessWidget {
  const CompanySliverTabBar({
    super.key,
    required TabController tabController,
    required this.categories,
    required this.scrollToCategory,
  }) : _tabController = tabController;

  final TabController _tabController;
  final List<CategoryModel> categories;
  final Function(int) scrollToCategory;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CompanySliverTabBarDelegate(
        TabBar(
          onTap: (index) => scrollToCategory(index),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: ColorConstants.primaryColor,
          labelColor: ColorConstants.black,
          unselectedLabelColor: Colors.grey,
          tabs: categories
              .map(
                (category) => Tab(
                  text: category.name,
                ),
              )
              .toList(),
        ),
      ),
      pinned: true,
    );
  }
}

class CompanySliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  CompanySliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).canvasColor),
        color: Theme.of(context).canvasColor,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(CompanySliverTabBarDelegate oldDelegate) {
    return false;
  }
}
