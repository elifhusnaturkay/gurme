import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
import 'package:gurme/features/home/drawers/favorites_drawer.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GeoPoint? userLocation;
    if (ref.read(locationProvider.notifier).state != null) {
      userLocation = GeoPoint(
          ref.read(locationProvider.notifier).state!.latitude,
          ref.read(locationProvider.notifier).state!.longitude);
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
                    color: Colors.indigo.shade400,
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
                        color: Colors.black,
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
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).canvasColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20, 17),
                            topRight: Radius.elliptical(20, 17),
                          ),
                        ),
                        enableDrag: true,
                        useSafeArea: true,
                        builder: (context) {
                          bool isAuthenticated = ref
                              .watch(userProvider.notifier)
                              .state!
                              .isAuthenticated;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: isAuthenticated
                                ? [
                                    ListTile(
                                      onTap: () {
                                        context.pushNamed(
                                          RouteConstants.profileScreen,
                                          pathParameters: {
                                            "id": ref
                                                .read(userProvider.notifier)
                                                .state!
                                                .uid
                                          },
                                        );
                                      },
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      92, 107, 192, 0.5),
                                              radius: 16,
                                              child: CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        92, 107, 192, 0.5),
                                                backgroundImage: NetworkImage(
                                                  ref
                                                      .watch(
                                                          userProvider.notifier)
                                                      .state!
                                                      .profilePic,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Profile Git",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.indigo.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .signOut(context);
                                      },
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout_rounded,
                                              color: Colors.indigo.shade400,
                                              size: 32,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Çıkış Yap",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.indigo.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    ListTile(
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            context.pop();
                                            context.pushNamed(
                                              RouteConstants.loginScreen,
                                            );
                                          },
                                          label: Text(
                                            "Giriş Yap ya da Kayıt Ol",
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo.shade400,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.login_rounded,
                                            color: Colors.indigo.shade400,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                          );
                        },
                      );
                    },
                    constraints: const BoxConstraints(),
                    iconSize: 32,
                    icon: CircleAvatar(
                      backgroundColor: Colors.indigo.shade400.withOpacity(0.5),
                      radius: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor:
                            const Color.fromRGBO(92, 107, 192, 0.5),
                        backgroundImage: NetworkImage(
                          ref.watch(userProvider.notifier).state!.profilePic,
                        ),
                      ),
                    ),
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
                    enableInfiniteScroll: true,
                  ),
                  items: ref.watch(getPopularItemsProvider).when(
                        data: (items) {
                          return items.map(
                            (item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      showPopUpScreen(
                                        context: context,
                                        builder: (context) {
                                          return ItemScreen(
                                            item: item,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(92, 107, 192, 0.2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              item.picture,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    6,
                                                    4,
                                                    6,
                                                    5,
                                                  ),
                                                  child: Text(
                                                    item.companyName,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    6,
                                                    4,
                                                    6,
                                                    5,
                                                  ),
                                                  child: Text(
                                                    item.name,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (userLocation != null)
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE9EAFF),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(6),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  4,
                                                  2,
                                                  2,
                                                  2,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      LocationUtils
                                                          .calculateDistance(
                                                              userLocation
                                                                  .latitude,
                                                              userLocation
                                                                  .longitude,
                                                              item.location
                                                                  .latitude,
                                                              item.location
                                                                  .longitude),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Icon(
                                                      Icons.location_pin,
                                                      size: 18,
                                                      color: Colors
                                                          .indigo.shade400,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    4,
                                                    2,
                                                    4,
                                                    2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        item.rating
                                                            .toStringAsFixed(1),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
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
                                                        item.ratingCount
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    4,
                                                    2,
                                                    2,
                                                    2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        item.commentCount
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.chat_rounded,
                                                        color: Colors
                                                            .indigo.shade400,
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
                            },
                          ).toList();
                        },
                        error: ((error, stackTrace) {
                          return [Text(error.toString())];
                        }),
                        loading: () => [
                          Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: Colors.indigo.shade400,
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
                    enableInfiniteScroll: true,
                  ),
                  items: ref.watch(getPopularCompaniesProvider).when(
                        data: (companies) {
                          return companies.map(
                            (company) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () => context.pushNamed(
                                      RouteConstants.companyScreen,
                                      pathParameters: {"id": company.id},
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(92, 107, 192, 0.2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              company.bannerPic,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE9EAFF),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(6),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                6,
                                                4,
                                                6,
                                                5,
                                              ),
                                              child: Text(
                                                company.name,
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (userLocation != null)
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE9EAFF),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(6),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  4,
                                                  2,
                                                  2,
                                                  2,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      LocationUtils
                                                          .calculateDistance(
                                                              userLocation
                                                                  .latitude,
                                                              userLocation
                                                                  .longitude,
                                                              company.location
                                                                  .latitude,
                                                              company.location
                                                                  .longitude),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Icon(
                                                      Icons.location_pin,
                                                      size: 18,
                                                      color: Colors
                                                          .indigo.shade400,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    4,
                                                    2,
                                                    4,
                                                    2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        company.rating
                                                            .toStringAsFixed(1),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
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
                                                        company.ratingCount
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFE9EAFF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    4,
                                                    2,
                                                    2,
                                                    2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        company.commentCount
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.chat_rounded,
                                                        color: Colors
                                                            .indigo.shade400,
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
                              color: Colors.indigo.shade400,
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
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                RouteConstants
                                                    .filteredSearchScreen,
                                              );
                                            },
                                            child: Container(
                                              height: 75,
                                              width: 75,
                                              margin: const EdgeInsets.fromLTRB(
                                                  8, 0, 8, 0),
                                              decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    92, 107, 192, 0.2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: Image.network(
                                                  category.picture,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: 100,
                                            height: 40,
                                            child: Text(
                                              category.name,
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
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
                                  color: Colors.indigo.shade400,
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
                              (index) => Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      showPopUpScreen(
                                        context: context,
                                        builder: (context) {
                                          return ItemScreen(
                                            item: randomItems[index],
                                          );
                                        },
                                      );
                                    },
                                    title: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  randomItems[index].picture,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  randomItems[index].name,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  randomItems[index]
                                                      .companyName,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      randomItems[index]
                                                          .rating
                                                          .toStringAsFixed(1),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Icon(
                                                      Icons.grade_rounded,
                                                      size: 18,
                                                      color: Colors.amber,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      randomItems[index]
                                                          .commentCount
                                                          .toString(),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.chat_rounded,
                                                      color: Colors
                                                          .indigo.shade400,
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
                                        index != randomItems.length - 1
                                            ? const SizedBox(height: 10)
                                            : const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  index != randomItems.length - 1
                                      ? Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              80, 0, 20, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 1,
                                          color: Colors.grey.shade300,
                                        )
                                      : const SizedBox(),
                                ],
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
                              color: Colors.indigo.shade400,
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
