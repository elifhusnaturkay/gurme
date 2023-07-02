import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/features/company/controller/company_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class CompanyScreen extends ConsumerStatefulWidget {
  final String _id;
  const CompanyScreen({super.key, required String id}) : _id = id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen>
    with TickerProviderStateMixin {
  late AutoScrollController _autoScrollController;
  //final List<int> categories = [1, 2, 3, 4, 5];
  // final List<int> items = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _autoScrollController = AutoScrollController();
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(companyDataProvider(widget._id)).when(
              data: (companyData) {
                final tabController = TabController(
                    length: companyData.categories.length, vsync: this);
                return VerticalScrollableTabView(
                  autoScrollController: _autoScrollController,
                  listItemData: companyData.categories,
                  tabController: tabController,
                  eachItemChild: (object, categoryIndex) {
                    return SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyData.categories[categoryIndex].name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  companyData.items[categoryIndex].length,
                              itemBuilder:
                                  (BuildContext context, int itemIndex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            companyData
                                                .items[categoryIndex][itemIndex]
                                                .name,
                                            style: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '4.5',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade400,
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
                                                    '150+',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    '100',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.chat_rounded,
                                                    color:
                                                        Colors.indigo.shade400,
                                                    size: 12,
                                                  ),
                                                  const SizedBox(width: 2),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      itemIndex != companyData.items.length - 1
                                          ? const SizedBox(height: 15)
                                          : const SizedBox(),
                                      itemIndex != companyData.items.length - 1
                                          ? Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  80, 0, 20, 0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 1,
                                              color: Colors.grey.shade300,
                                            )
                                          : const SizedBox(),
                                      itemIndex != companyData.items.length - 1
                                          ? const SizedBox(height: 10)
                                          : const SizedBox(height: 15),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: false,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              AssetConstants.defaultBannerPic,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      backgroundColor: Theme.of(context).canvasColor,
                      elevation: 0,
                      pinned: true,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: Platform.isAndroid
                            ? EdgeInsets.fromLTRB(15,
                                MediaQuery.of(context).padding.top - 5, 15, 0)
                            : EdgeInsets.fromLTRB(15,
                                MediaQuery.of(context).padding.top - 25, 15, 0),
                        centerTitle: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Restoran",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Text(
                                    "4.5",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    size: 20,
                                    Icons.grade_rounded,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "150+",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 10),
                    ),
                    SliverToBoxAdapter(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 1,
                          enableInfiniteScroll: true,
                        ),
                        items: ref
                            .watch(getPoularItemsProvider(widget._id))
                            .when(
                                data: (popularItems) {
                                  return popularItems.map(
                                    (popularItem) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 5, 15, 5),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  92, 107, 192, 0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            child: Column(children: [
                                              Text(popularItem.name),
                                              Text(popularItem.rating
                                                  .toString()),
                                              Text(popularItem.ratingCount
                                                  .toString()),
                                            ]),
                                          );
                                        },
                                      );
                                    },
                                  ).toList();
                                },
                                error: ((error, stackTrace) {
                                  return [Text(error.toString())];
                                }),
                                loading: () =>
                                    [const CircularProgressIndicator()]),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 15),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: tabController,
                          isScrollable: true,
                          indicatorColor: Colors.indigo.shade400,
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          tabs: companyData.categories
                              .map(
                                (category) => Tab(
                                  text: category.name,
                                ),
                              )
                              .toList(),
                          onTap: (index) {
                            VerticalScrollableTabBarStatus.setIndex(index);
                          },
                        ),
                      ),
                      pinned: true,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 15),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).canvasColor),
        color: Theme.of(context).canvasColor,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
