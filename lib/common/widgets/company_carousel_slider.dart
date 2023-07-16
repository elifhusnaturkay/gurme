import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/models/company_model.dart';

class CompanyCarouselSlider extends StatefulWidget {
  const CompanyCarouselSlider({
    super.key,
    required this.userLocation,
    required this.company,
  });

  final Company company;
  final GeoPoint? userLocation;

  @override
  State<CompanyCarouselSlider> createState() => _CompanyCarouselSliderState();
}

class _CompanyCarouselSliderState extends State<CompanyCarouselSlider>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => context.pushNamed(
            RouteConstants.companyScreen,
            pathParameters: {"id": widget.company.id},
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(92, 107, 192, 0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Image.network(
                    widget.company.bannerPic,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorConstants.secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      6,
                      4,
                      6,
                      5,
                    ),
                    child: Text(
                      widget.company.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                if (widget.userLocation != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorConstants.secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        4,
                        2,
                        2,
                        2,
                      ),
                      child: Row(
                        children: [
                          Text(
                            LocationUtils.calculateDistance(
                                widget.userLocation!.latitude,
                                widget.userLocation!.longitude,
                                widget.company.location.latitude,
                                widget.company.location.longitude),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8),
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
                    ),
                  ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: ColorConstants.secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          4,
                          2,
                          4,
                          2,
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.company.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.grade_rounded,
                              size: 18,
                              color: ColorConstants.starColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: ColorConstants.secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          4,
                          2,
                          2,
                          2,
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.company.commentCount.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.chat_rounded,
                              color: ColorConstants.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
