import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';

class FavoritesDrawer extends StatelessWidget {
  const FavoritesDrawer({super.key});

  final companies = const [
    1,
    2,
    3,
    4,
    5,
    6,
    1,
    2,
    3,
    4,
    5,
    6,
    1,
    2,
    3,
    4,
    5,
    6,
    1,
    2,
    3,
    4,
    5,
    6
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: ListTile(
              title: Text(
                "Favoriler",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...List.generate(
                  companies.length,
                  (index) {
                    return ListTile(
                      onTap: () {}, // TODO: Navigation
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
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
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    AssetConstants
                                        .defaultBannerPic, // TODO: Banner Pic
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "company.name", // TODO : Name
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
                                        4.5.toString(), // TODO : Raitng
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
                                        "100", // TODO : Rating Count
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
                                  Row(
                                    children: [
                                      Text(
                                        "100", // TODO : Comment Count
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.chat_rounded,
                                        color: Colors.indigo.shade400,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          index != companies.length - 1
                              ? const SizedBox(height: 5)
                              : const SizedBox(),
                          index != companies.length - 1
                              ? Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(80, 0, 20, 0),
                                  width: MediaQuery.of(context).size.width,
                                  height: 1,
                                  color: Colors.grey.shade300,
                                )
                              : const SizedBox(height: 5),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
