import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/models/item_model.dart';

class ItemCarouselSlider extends StatefulWidget {
  const ItemCarouselSlider({
    super.key,
    required this.userLocation,
    required this.item,
    required this.isCompanyScreen,
  });

  final GeoPoint? userLocation;
  final Item item;
  final bool isCompanyScreen;

  @override
  State<ItemCarouselSlider> createState() => _ItemCarouselSliderState();
}

class _ItemCarouselSliderState extends State<ItemCarouselSlider>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            showPopUpScreen(
              context: context,
              builder: (context) {
                return ItemScreen(
                  item: widget.item,
                );
              },
            );
          },
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
                    widget.item.picture,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isCompanyScreen
                          ? Container()
                          : Container(
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
                                widget.item.companyName,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black.withOpacity(0.8),
                                ),
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
                          6,
                          4,
                          6,
                          5,
                        ),
                        child: Text(
                          widget.item.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.userLocation != null && !widget.isCompanyScreen
                    ? Positioned(
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
                                    widget.item.location.latitude,
                                    widget.item.location.longitude),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black.withOpacity(0.8),
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
                      )
                    : Container(),
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
                              widget.item.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.black.withOpacity(0.8),
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
                              widget.item.commentCount.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.black.withOpacity(0.8),
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
