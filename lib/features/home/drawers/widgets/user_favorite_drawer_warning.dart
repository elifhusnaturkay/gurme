import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserFavoritesDrawerWarning extends StatelessWidget {
  const UserFavoritesDrawerWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "En sevdiğin restoran ve kafelerini favorilemeyi unutma!",
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
