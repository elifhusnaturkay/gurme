import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:gurme/common/utils/lose_focus.dart';
import 'package:gurme/common/widgets/no_background_company_list_tile.dart';
import 'package:gurme/common/widgets/no_background_item_list_tile.dart';
import 'package:gurme/core/providers/global_providers.dart';
import 'package:gurme/features/search/controller/search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimationItem;
  late Animation<Color?> _colorAnimationCompany;
  bool isSearchingItems = true;

  @override
  void initState() {
    searchController = TextEditingController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _colorAnimationItem = ColorTween(
      begin: ColorConstants.primaryColor,
      end: const Color.fromRGBO(92, 107, 192, 0.5),
    ).animate(_animationController);

    _colorAnimationCompany = ColorTween(
      begin: const Color.fromRGBO(92, 107, 192, 0.5),
      end: ColorConstants.primaryColor,
    ).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GeoPoint? userLocation;
    if (ref.watch(locationProvider.notifier).state != null) {
      userLocation = GeoPoint(
          ref.watch(locationProvider.notifier).state!.latitude,
          ref.watch(locationProvider.notifier).state!.longitude);
    }
    return GestureDetector(
      onTap: loseFocus,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 55),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Hero(
                tag: "hometosearch",
                child: AppBar(
                  leadingWidth: 40,
                  titleSpacing: 0,
                  iconTheme: const IconThemeData(
                    color: ColorConstants.black,
                  ),
                  shape: Border(
                    top: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  centerTitle: false,
                  elevation: 0,
                  title: SizedBox(
                    width:
                        200 + ((MediaQuery.of(context).size.width - 393) * 0.5),
                    child: TextField(
                      controller: searchController,
                      cursorColor: ColorConstants.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bugün canın ne çekiyor?',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15 +
                              ((MediaQuery.of(context).size.width - 393) *
                                  0.05),
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(queryProvider.notifier)
                            .update((state) => value);
                      },
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Text(
                            'Ürün',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _colorAnimationItem.value,
                            ),
                          ),
                          onTap: () {
                            if (!isSearchingItems) {
                              setState(() {
                                isSearchingItems = !isSearchingItems;
                              });
                              _animationController.reverse();
                            }
                          },
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '/',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(92, 107, 192, 0.5),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          child: Text(
                            'Restoran',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _colorAnimationCompany.value,
                            ),
                          ),
                          onTap: () {
                            if (isSearchingItems) {
                              setState(() {
                                isSearchingItems = !isSearchingItems;
                              });
                              _animationController.forward();
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
          ),
        ),
        body: isSearchingItems
            ? ref.watch(searchItemProvider).when(
                  data: (items) {
                    if (items.isEmpty && searchController.text.length > 3) {
                      return const Center(
                        child: Text('Maalesef aradığınız ürün bulunamadı'),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              const SizedBox(height: 5),
                              ...List.generate(
                                items.length,
                                (index) {
                                  final item = items[index];
                                  return NoBackgroundItemListTile(
                                    item: item,
                                    length: items.length,
                                    index: index,
                                    isCompanyScreen: false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => Center(
                    child: LoadingAnimationWidget.waveDots(
                      color: ColorConstants.primaryColor,
                      size: 50,
                    ),
                  ),
                )
            : ref.watch(searchCompanyProvider).when(
                  data: (companies) {
                    if (companies.isEmpty && searchController.text.length > 3) {
                      return const Center(
                        child: Text('Maalesef aradığınız restoran bulunamadı'),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              const SizedBox(height: 5),
                              ...List.generate(
                                companies.length,
                                (index) {
                                  final company = companies[index];
                                  return NoBackgroundCompanyListTile(
                                    company: company,
                                    userLocation: userLocation,
                                    index: index,
                                    length: companies.length,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => Center(
                    child: LoadingAnimationWidget.waveDots(
                      color: ColorConstants.primaryColor,
                      size: 50,
                    ),
                  ),
                ),
      ),
    );
  }
}
