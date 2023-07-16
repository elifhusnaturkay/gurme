import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';

class EditProfileInformation extends ConsumerWidget {
  const EditProfileInformation({
    super.key,
    required this.isMailUser,
    required this.ref,
  });

  final bool isMailUser;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier).state!;
    return Column(
      children: [
        ListTile(
          title: Text(
            "Bilgilerin",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            context.pushNamed(RouteConstants.editNameScreen,
                pathParameters: {"name": user.name});
          },
          title: Text(
            "Ad Soyad",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: ColorConstants.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: ColorConstants.black,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              )
            ],
          ),
        ),
        isMailUser
            ? ListTile(
                onTap: () {
                  String? email = ref
                      .read(profileControllerProvider.notifier)
                      .getCurrentUserEmail();
                  if (email != null) {
                    ref
                        .read(authControllerProvider.notifier)
                        .sendResetEmail(email);
                  }
                },
                title: Text(
                  "Şifre",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: ColorConstants.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sıfırlama Bağlantısını Gönder",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: ColorConstants.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
