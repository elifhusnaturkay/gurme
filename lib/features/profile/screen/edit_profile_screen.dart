import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/features/profile/widgets/edit_profile_app_bar.dart';
import 'package:gurme/features/profile/widgets/edit_profile_information.dart';

enum ImageName {
  profile,
  banner;
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late bool isMailUser;

  @override
  void initState() {
    super.initState();
    isMailUser =
        ref.read(profileControllerProvider.notifier).isUserSignedInWithMail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(225),
        child: EditProfileAppBar(
          ref: ref,
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: EditProfileInformation(
          isMailUser: isMailUser,
          ref: ref,
        ),
      ),
    );
  }
}
