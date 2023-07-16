import 'package:flutter/material.dart';
import 'package:gurme/common/constants/color_constants.dart';

class ProfileSilverTabBar extends StatelessWidget {
  const ProfileSilverTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: ProfileSliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: ColorConstants.primaryColor,
          labelColor: ColorConstants.black,
          unselectedLabelColor: Colors.grey,
          tabs: ["Yorumlar", "Favoriler"]
              .map(
                (category) => Tab(
                  text: category,
                ),
              )
              .toList(),
        ),
      ),
      pinned: true,
    );
  }
}

class ProfileSliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  ProfileSliverTabBarDelegate(this._tabBar);

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
            color: ColorConstants.black.withOpacity(0.25),
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
  bool shouldRebuild(ProfileSliverTabBarDelegate oldDelegate) {
    return false;
  }
}
