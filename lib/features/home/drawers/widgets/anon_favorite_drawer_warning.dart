import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';

class AnonFavoriteDrawerWarning extends StatelessWidget {
  const AnonFavoriteDrawerWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 10),
          title: Text(
            "Favori restoran ve kafelerine daha hızlı ulaşabilmek için giriş yap!",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
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
