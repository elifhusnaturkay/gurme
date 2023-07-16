import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/string_constants.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({
    super.key,
    required this.isNotFound,
  });

  final bool isNotFound;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetConstants.shortLogoPurple,
                height: 80,
              ),
              const SizedBox(width: 10),
              Text(
                "404",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 60,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          isNotFound
              ? Text(
                  ErrorMessageConstants.notFoundError,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: ColorConstants.black,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                )
              : Text(
                  ErrorMessageConstants.somethingWentWrong,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: ColorConstants.black,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
        ],
      ),
    );
  }
}
