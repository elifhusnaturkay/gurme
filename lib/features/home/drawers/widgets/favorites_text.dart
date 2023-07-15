import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesText extends StatelessWidget {
  const FavoritesText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Favoriler",
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
