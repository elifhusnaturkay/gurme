import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
    required this.isAuthenticated,
    required this.ref,
  });

  final bool isAuthenticated;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: isAuthenticated
          ? [
              ListTile(
                onTap: () {
                  context.pushNamed(
                    RouteConstants.profileScreen,
                    pathParameters: {
                      "id": ref.read(userProvider.notifier).state!.uid
                    },
                  );
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromRGBO(92, 107, 192, 0.5),
                        radius: 16,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              const Color.fromRGBO(92, 107, 192, 0.5),
                          backgroundImage: NetworkImage(
                            ref.watch(userProvider.notifier).state!.profilePic,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Profile Git",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: ColorConstants.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Çıkış Yap",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : [
              ListTile(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      context.pop();
                      context.pushNamed(
                        RouteConstants.loginScreen,
                      );
                    },
                    label: Text(
                      "Giriş Yap ya da Kayıt Ol",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.login_rounded,
                      color: ColorConstants.primaryColor,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
