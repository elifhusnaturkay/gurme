import 'package:flutter/material.dart';

class CompanySliverTabBar extends SliverPersistentHeaderDelegate {
  CompanySliverTabBar(this._tabBar);

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
  bool shouldRebuild(CompanySliverTabBar oldDelegate) {
    return false;
  }
}
