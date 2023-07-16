import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/models/company_model.dart';

class CopmanyInformationSliverAppBar extends StatelessWidget {
  const CopmanyInformationSliverAppBar({
    super.key,
    required this.userLocation,
    required this.company,
  });

  final Company company;
  final GeoPoint? userLocation;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(
            15, MediaQuery.of(context).padding.top + 5, 15, 0),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  company.name,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      company.rating.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.grade_rounded,
                      size: 18,
                      color: ColorConstants.starColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "(${company.ratingCount})",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                if (userLocation != null)
                  Row(
                    children: [
                      Text(
                        LocationUtils.calculateDistance(
                            userLocation!.latitude,
                            userLocation!.longitude,
                            company.location.latitude,
                            company.location.longitude),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.location_pin,
                        size: 18,
                        color: ColorConstants.primaryColor,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
