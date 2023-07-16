import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/show_bottom_sheet.dart';
import 'package:gurme/common/widgets/company_carousel_slider.dart';
import 'package:gurme/common/widgets/item_carousel_slider.dart';
import 'package:gurme/common/widgets/no_background_item_list_tile.dart';
import 'package:gurme/core/providers/global_providers.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
import 'package:gurme/features/home/drawers/favorites_drawer.dart';
import 'package:gurme/features/home/widgets/home_app_bar_avatar.dart';
import 'package:gurme/features/home/widgets/home_category_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GeoPoint? userLocation;
    if (ref.watch(locationProvider.notifier).state != null) {
      userLocation = GeoPoint(
          ref.watch(locationProvider.notifier).state!.latitude,
          ref.watch(locationProvider.notifier).state!.longitude);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      drawer: const FavoritesDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Hero(
              tag: "hometosearch",
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).canvasColor,
                foregroundColor: const Color.fromRGBO(246, 246, 246, 0.5),
                elevation: 2,
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
                    color: ColorConstants.primaryColor,
                  ),
                ),
                leading: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: ColorConstants.black,
                        size: 25,
                      ),
                    );
                  },
                ),
                actions: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      context.pushNamed(RouteConstants.searchScreen);
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      color: ColorConstants.black,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showHomeBottomSheet(context, ref);
                    },
                    constraints: const BoxConstraints(),
                    iconSize: 32,
                    icon: HomeAppBarAvatar(ref: ref),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                    "En Popüler Ürünler",
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
                    enableInfiniteScroll: false,
                  ),
                  items: ref.watch(getPopularItemsProvider).when(
                        data: (items) {
                          return items.map(
                            (item) {
                              return ItemCarouselSlider(
                                userLocation: userLocation,
                                item: item,
                                isCompanyScreen: false,
                              );
                            },
                          ).toList();
                        },
                        error: ((error, stackTrace) {
                          return [Text(error.toString())];
                        }),
                        loading: () => [
                          Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: ColorConstants.primaryColor,
                              size: 50,
                            ),
                          ),
                        ],
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
                    "En Popüler Restoranlar",
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
                    enableInfiniteScroll: false,
                  ),
                  items: ref.watch(getPopularCompaniesProvider).when(
                        data: (companies) {
                          return companies.map(
                            (company) {
                              return CompanyCarouselSlider(
                                userLocation: userLocation,
                                company: company,
                              );
                            },
                          ).toList();
                        },
                        error: ((error, stackTrace) {
                          return [
                            Text(
                              error.toString(),
                            ),
                          ];
                        }),
                        loading: () => [
                          Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: ColorConstants.primaryColor,
                              size: 50,
                            ),
                          ),
                        ],
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
                    "Kategoriler",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: ref.watch(getCategoriesProvider).when(
                            data: (categories) {
                              return categories.map(
                                (category) {
                                  return HomeCategoryBuilder(
                                    ref: ref,
                                    category: category,
                                  );
                                },
                              ).toList();
                            },
                            error: (error, stackTrace) {
                              return [Text(error.toString())];
                            },
                            loading: () => [
                              Center(
                                child: LoadingAnimationWidget.waveDots(
                                  color: ColorConstants.primaryColor,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                  children: ref.watch(getRandomItemsProvider).when(
                        data: (randomItems) {
                          return [
                            const SizedBox(height: 5),
                            ...List.generate(
                              randomItems.length,
                              (index) => NoBackgroundItemListTile(
                                item: randomItems[index],
                                length: randomItems.length,
                                index: index,
                                isCompanyScreen: false,
                              ),
                            ),
                          ];
                        },
                        error: ((error, stackTrace) {
                          return [
                            Text(
                              error.toString(),
                            ),
                          ];
                        }),
                        loading: () => [
                          Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: ColorConstants.primaryColor,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
