import 'package:flutter/material.dart';

class ProfileSpaceAppBar extends StatelessWidget {
  const ProfileSpaceAppBar({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).canvasColor,
      expandedHeight: 120 + ((screenWidth - 393) * 0.3),
      collapsedHeight: 60 + ((screenWidth - 393) * 0.3),
      toolbarHeight: 60 + ((screenWidth - 393) * 0.3),
      pinned: true,
      elevation: 0,
      flexibleSpace: Container(
        height: 120 + ((screenWidth - 393) * 0.3),
        width: screenWidth,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0,
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
      ),
    );
  }
}
