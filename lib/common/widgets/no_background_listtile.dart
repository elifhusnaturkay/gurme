import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/models/item_model.dart';

class NoBackgroundListTile extends StatelessWidget {
  const NoBackgroundListTile({
    super.key,
    required this.item,
    required this.length,
    required this.index,
    required this.isCompanyScreen,
  });

  final Item item;
  final int length;
  final int index;
  final bool isCompanyScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            showPopUpScreen(
              context: context,
              builder: (context) {
                return ItemScreen(item: item);
              },
            );
          },
          title: Column(
            children: [
              const SizedBox(height: 10),
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
                        item.picture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.inter(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isCompanyScreen
                          ? const SizedBox()
                          : const SizedBox(height: 5),
                      isCompanyScreen
                          ? const SizedBox()
                          : Text(
                              item.companyName,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.rating.toStringAsFixed(1),
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
                            "(${item.ratingCount})",
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
                            item.commentCount.toString(),
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
                            size: 12,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              index != length - 1
                  ? const SizedBox(height: 10)
                  : const SizedBox(height: 10),
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
