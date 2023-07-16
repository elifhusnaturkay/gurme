import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/string_constants.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/features/profile/screen/edit_profile_screen.dart';
import 'package:gurme/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileAppBar extends StatefulWidget {
  const EditProfileAppBar({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  State<EditProfileAppBar> createState() => _EditProfileAppBarState();
}

class _EditProfileAppBarState extends State<EditProfileAppBar> {
  File? selectedBanner;
  File? selectedProfile;

  Future<bool> uploadProfilePicture(
      UserModel user, File newProfilePicture) async {
    return await widget.ref
        .read(profileControllerProvider.notifier)
        .uploadProfilePicture(user, newProfilePicture);
  }

  Future<bool> uploadBannerPicture(
    UserModel user,
    File newBannerPicture,
  ) async {
    return await widget.ref
        .read(profileControllerProvider.notifier)
        .uploadBannerPicture(user, newBannerPicture);
  }

  Future selectFile(ImageName imageName, ImageSource imageSource) async {
    late XFile? result;
    try {
      result = await ImagePicker().pickImage(source: imageSource);
    } catch (e) {
      showToast(ErrorMessageConstants.somethingWentWrong);
    }
    if (result == null) return;

    setState(() {
      if (imageName == ImageName.banner) {
        selectedBanner = File(result!.path);
      } else {
        selectedProfile = File(result!.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.ref.watch(userProvider.notifier).state!;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: SizedBox(
        height: 225,
        child: Stack(
          children: [
            SizedBox(
              height: 175,
              child: InkWell(
                onTap: () async {
                  await showCameraOrGalleryBottomSheet(
                    context: context,
                    imageName: ImageName.banner,
                    selectFile: selectFile,
                  );
                  if (selectedBanner != null) {
                    await uploadBannerPicture(user, selectedBanner!);
                  }
                },
                splashFactory: NoSplash.splashFactory,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          color: ColorConstants.black.withOpacity(0.5),
                        ),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              blurStyle: BlurStyle.outer,
                              color: ColorConstants.black,
                              offset: Offset(0, -4),
                              spreadRadius: 4,
                            )
                          ],
                        ),
                        child: selectedBanner != null
                            ? Image.file(
                                selectedBanner!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const Icon(
                      Icons.add_a_photo_rounded,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 40,
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    await showCameraOrGalleryBottomSheet(
                      context: context,
                      imageName: ImageName.profile,
                      selectFile: selectFile,
                    );
                    if (selectedProfile != null) {
                      await uploadProfilePicture(user, selectedProfile!);
                    }
                  },
                  splashFactory: NoSplash.splashFactory,
                  customBorder: const CircleBorder(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: "profiletoedit",
                        child: Container(
                          height: 100,
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFCFD3ED),
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                            color: ColorConstants.black.withOpacity(0.5),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: ColorConstants.black.withOpacity(0.25),
                                offset: const Offset(0, 2),
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          child: selectedProfile != null
                              ? CircleAvatar(
                                  backgroundColor: ColorConstants.primaryColor
                                      .withOpacity(0.2),
                                  radius: 50,
                                  backgroundImage: FileImage(
                                    selectedProfile!,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: ColorConstants.primaryColor
                                      .withOpacity(0.2),
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    user.profilePic,
                                  ),
                                ),
                        ),
                      ),
                      const Icon(
                        Icons.add_a_photo_rounded,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
