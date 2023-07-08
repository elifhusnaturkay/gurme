import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/utils/location_utils.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/core/providers/global_keys.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/company/controller/company_controller.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CompanyScreen extends ConsumerStatefulWidget {
  final String _id;
  const CompanyScreen({super.key, required String id}) : _id = id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen>
    with TickerProviderStateMixin {
  late AutoScrollController _autoScrollController;
  late TabController _tabController;
  Map<int, dynamic> itemsKeys = {};

  @override
  void initState() {
    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    super.initState();
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(int catergoryIndex) {
    _autoScrollController.scrollToIndex(
      catergoryIndex,
      duration: const Duration(milliseconds: 300),
    );
  }

  List<int> _getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(rectGetter);
    List<int> items = [];
    if (rect == null) return items;

    itemsKeys.forEach(
      (index, key) {
        Rect? itemRect = RectGetter.getRectFromKey(key);
        if (itemRect == null) return;

        if (itemRect.top > rect.bottom) return;
        if (0 <
            rect.top +
                MediaQuery.of(context).viewPadding.top +
                kToolbarHeight -
                itemRect.top) return;

        items.add(index);
      },
    );
    return items;
  }

  bool _onScroll(UserScrollNotification userScrollNotification) {
    List<int> visibleItems = _getVisibleItemsIndex();
    _tabController.animateTo(
      visibleItems[0],
      curve: Curves.ease,
      duration: const Duration(milliseconds: 500),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    GeoPoint? userLocation;
    if (ref.read(userProvider.notifier).state?.currentLocation != null) {
      userLocation = GeoPoint(
          ref.read(userProvider.notifier).state!.currentLocation!.latitude,
          ref.read(userProvider.notifier).state!.currentLocation!.longitude);
    }
    return ref.watch(companyDataProvider(widget._id)).when(
          data: (companyData) {
            _tabController = TabController(
                length: companyData.categories.length, vsync: this);
            return NotificationListener<UserScrollNotification>(
              onNotification: _onScroll,
              child: Scaffold(
                key: rectGetter,
                body: CustomScrollView(
                  controller: _autoScrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: false,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              companyData.company.bannerPic,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () async {
                                return await LocationUtils.showOnMap(
                                    context, companyData.company.location);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE9EAFF),
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
                                      "Haritada Göster",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.near_me_rounded,
                                      size: 18,
                                      color: Colors.indigo.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Theme.of(context).canvasColor,
                      elevation: 0,
                      pinned: true,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.fromLTRB(
                            15, MediaQuery.of(context).padding.top + 5, 15, 0),
                        centerTitle: false,
                        title: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    companyData.company.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        companyData.company.rating.toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
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
                                        companyData.company.ratingCount
                                            .toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
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
                                              userLocation.latitude,
                                              userLocation.longitude,
                                              companyData
                                                  .company.location.latitude,
                                              companyData
                                                  .company.location.longitude),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          Icons.location_pin,
                                          size: 18,
                                          color: Colors.indigo.shade400,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
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
                        items: companyData.popularItems.map(
                          (popularItem) {
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
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: Image.network(
                                          popularItem.picture,
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
                                                popularItem.companyName,
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
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
                                                popularItem.name,
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE9EAFF),
                                                borderRadius: BorderRadius.all(
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
                                                    popularItem.rating
                                                        .toString(),
                                                    style: GoogleFonts.inter(
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
                                                    popularItem.ratingCount
                                                        .toString(),
                                                    style: GoogleFonts.inter(
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
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE9EAFF),
                                                borderRadius: BorderRadius.all(
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
                                                    popularItem.commentCount
                                                        .toString(),
                                                    style: GoogleFonts.inter(
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
                                                    color:
                                                        Colors.indigo.shade400,
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
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 15),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          onTap: (index) => _scrollToCategory(index),
                          controller: _tabController,
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
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        List.generate(
                          companyData.categories.length,
                          (categoryIndex) {
                            itemsKeys[categoryIndex] =
                                RectGetter.createGlobalKey();
                            return RectGetter(
                              key: itemsKeys[categoryIndex],
                              child: AutoScrollTag(
                                key: ValueKey(categoryIndex),
                                index: categoryIndex,
                                controller: _autoScrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 8, 8, 20),
                                      child: Text(
                                        companyData
                                            .categories[categoryIndex].name,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: companyData.items[categoryIndex]
                                          .map(
                                            (item) => ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(8),
                                                          ),
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        child: Image.network(
                                                          item.picture,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Text(
                                                        item.name,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                item.rating
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              const Icon(
                                                                Icons
                                                                    .grade_rounded,
                                                                size: 18,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                item.ratingCount
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
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
                                                                item.commentCount
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chat_rounded,
                                                                color: Colors
                                                                    .indigo
                                                                    .shade400,
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
                                                  item !=
                                                          companyData.items[
                                                                  categoryIndex]
                                                              [companyData
                                                                      .items[
                                                                          categoryIndex]
                                                                      .length -
                                                                  1]
                                                      ? const SizedBox(
                                                          height: 15)
                                                      : const SizedBox(),
                                                  item !=
                                                          companyData.items[
                                                                  categoryIndex]
                                                              [companyData
                                                                      .items[
                                                                          categoryIndex]
                                                                      .length -
                                                                  1]
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  80, 0, 20, 0),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 1,
                                                          color: Colors
                                                              .grey.shade300,
                                                        )
                                                      : const SizedBox(),
                                                  item !=
                                                          companyData.items[
                                                                  categoryIndex]
                                                              [companyData
                                                                      .items[
                                                                          categoryIndex]
                                                                      .length -
                                                                  1]
                                                      ? const SizedBox(
                                                          height: 10)
                                                      : const SizedBox(
                                                          height: 15),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Scaffold(
            body: Center(
              child: LoadingSpinner(
                height: 75,
                width: 75,
              ),
            ),
          ),
        );
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
