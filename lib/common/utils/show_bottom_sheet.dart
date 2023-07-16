import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/home/widgets/home_bottom_sheet.dart';
import 'package:gurme/features/item/widgets/comment_field_screen.dart';
import 'package:gurme/features/profile/screen/edit_profile_screen.dart';
import 'package:gurme/features/profile/widgets/edit_profile_camera_or_gallery_bottom_sheet.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> showPopUpScreen({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    enableDrag: true,
    useSafeArea: true,
    builder: builder,
  );
}

Future<dynamic> showHomeBottomSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    enableDrag: true,
    useSafeArea: true,
    builder: (context) {
      bool isAuthenticated =
          ref.watch(userProvider.notifier).state!.isAuthenticated;
      return HomeBottomSheet(
        isAuthenticated: isAuthenticated,
        ref: ref,
      );
    },
  );
}

Future<dynamic> showCommentFieldBottomSheet(
  BuildContext context,
  WidgetRef ref,
  Item item,
  Comment? currentUserComment,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    enableDrag: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FocusScope(
          child: CommentFieldScreen(
            ref: ref,
            item: item,
            currentUserComment: currentUserComment,
          ),
        ),
      );
    },
  );
}

Future<dynamic> showCameraOrGalleryBottomSheet({
  required BuildContext context,
  required ImageName imageName,
  required Function(ImageName imageName, ImageSource imageSource) selectFile,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    builder: (context) {
      return CameraOrGalleryBottomSheet(
        imageName: imageName,
        selectFile: selectFile,
      );
    },
  );
}
