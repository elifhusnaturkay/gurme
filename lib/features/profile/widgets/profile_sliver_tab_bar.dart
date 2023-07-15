import 'package:flutter/material.dart';

class ProfileSliverTabBar extends SliverPersistentHeaderDelegate {
  ProfileSliverTabBar(this._tabBar);

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
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border(
          top: BorderSide(
            width: 0,
            color: Theme.of(context).canvasColor,
          ),
        ),
        color: Theme.of(context).canvasColor,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(ProfileSliverTabBar oldDelegate) {
    return false;
  }
}
