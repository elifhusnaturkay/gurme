import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/home/controller/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: AppBar(
              backgroundColor: const Color.fromRGBO(246, 246, 246, 0.5),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                side: BorderSide(
                  color: Color(0xFFE8E8E8),
                ),
              ),
              centerTitle: true,
              title: Text(
                "Gurme",
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo.shade400,
                ),
              ),
              leading: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteConstants.searchScreen);
                  },
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(92, 107, 192, 0.5),
                    radius: 15,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                        AssetConstants.defaultProfilePic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "En popüler ürünler",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                  ),
                  items: ref.watch(getPopularItemsProvider).when(
                        data: (items) {
                          return items.map(
                            (item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(92, 107, 192, 0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(item.name),
                                        Text(item.rating.toString()),
                                        Text(item.ratingCount.toString()),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ).toList();
                        },
                        error: ((error, stackTrace) {
                          return [Text(error.toString())];
                        }),
                        loading: () => [const CircularProgressIndicator()],
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "En popüler restoranlar",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                  ),
                  items: ref.watch(getPopularCompaniesProvider).when(
                        data: (companies) {
                          print('Companies LENGTH ${companies.length}');
                          return companies.map(
                            (company) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(92, 107, 192, 0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(company.name),
                                        Text(company.rating.toString()),
                                        Text(company.ratingCount.toString()),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ).toList();
                        },
                        error: ((error, stackTrace) {
                          return [Text(error.toString())];
                        }),
                        loading: () => [const CircularProgressIndicator()],
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mutfaklar",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 500,
                  height: 100,
                  child: ListView(
                    clipBehavior: Clip.hardEdge,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: ref.watch(getCategoriesProvider).when(
                          data: (categories) {
                            return categories.map(
                              (category) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: 100,
                                      margin: const EdgeInsets.fromLTRB(
                                          15, 0, 0, 0),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(92, 107, 192, 0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(category.picture),
                                    );
                                  },
                                );
                              },
                            ).toList();
                          },
                          error: ((error, stackTrace) {
                            return [Text(error.toString())];
                          }),
                          loading: () => [const CircularProgressIndicator()],
                        ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ürünler",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(92, 107, 192, 0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              Container(
                                height: 50,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "$i. Limonata",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
