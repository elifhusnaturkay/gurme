import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/widgets/item_carousel_slider.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/core/providers/global_providers.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/company/controller/company_controller.dart';
import 'package:gurme/features/company/widgets/company_banner_sliver_app_bar.dart';
import 'package:gurme/features/company/widgets/company_information_sliver_app_bar.dart';
import 'package:gurme/features/company/widgets/company_list_field.dart';
import 'package:gurme/features/company/widgets/company_sliver_tab_bar.dart';
import 'package:gurme/features/notfound/not_found_screen.dart';
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
    super.initState();
    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
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
    final user = ref.watch(userProvider.notifier).state!;

    GeoPoint? userLocation;
    if (ref.watch(locationProvider.notifier).state != null) {
      userLocation = GeoPoint(
        ref.watch(locationProvider.notifier).state!.latitude,
        ref.watch(locationProvider.notifier).state!.longitude,
      );
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
                  slivers: [
                    CompanyBannerSliverAppBar(
                      autoScrollController: _autoScrollController,
                      user: user,
                      company: companyData.company,
                      ref: ref,
                    ),
                    CopmanyInformationSliverAppBar(
                      userLocation: userLocation,
                      company: companyData.company,
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
                            return ItemCarouselSlider(
                              userLocation: userLocation,
                              item: popularItem,
                              isCompanyScreen: true,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 15),
                    ),
                    CompanySliverTabBar(
                      tabController: _tabController,
                      categories: companyData.categories,
                      scrollToCategory: _scrollToCategory,
                    ),
                    CompanyListField(
                      itemsKeys: itemsKeys,
                      autoScrollController: _autoScrollController,
                      companyData: companyData,
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => const NotFoundScreen(isNotFound: false),
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
