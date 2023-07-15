import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/models/company_model.dart';

class NoBackgroundCompanyListTile extends StatelessWidget {
  const NoBackgroundCompanyListTile(
      {super.key,
      required this.company,
      required this.userLocation,
      required this.index,
      required this.length});

  final Company company;
  final GeoPoint? userLocation;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => context.pushNamed(
            RouteConstants.companyScreen,
            pathParameters: {"id": company.id},
          ),
          title: Column(
            children: [
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        company.bannerPic,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    company.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            company.rating.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.grade_rounded,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            company.ratingCount.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade400,
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
                                company.location.longitude,
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Icon(
                              Icons.location_pin,
                              size: 16,
                              color: Colors.indigo.shade400,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        index != length - 1
            ? Container(
                margin: const EdgeInsets.fromLTRB(80, 0, 20, 0),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.grey.shade300,
              )
            : const SizedBox(),
      ],
    );
  }
}
