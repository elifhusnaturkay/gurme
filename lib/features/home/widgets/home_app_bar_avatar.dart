import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class HomeAppBarAvatar extends StatelessWidget {
  const HomeAppBarAvatar({
    super.key,
    required this.ref,
  });
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ColorConstants.primaryColor.withOpacity(0.5),
      radius: 16,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: const Color.fromRGBO(92, 107, 192, 0.5),
        backgroundImage: NetworkImage(
          ref.watch(userProvider.notifier).state!.profilePic,
        ),
      ),
    );
  }
}
