import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/notfound/not_found_screen.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/features/profile/widgets/profile_banner_app_bar.dart';
import 'package:gurme/features/profile/widgets/profile_comment_tile_company.dart';
import 'package:gurme/features/profile/widgets/profile_favorite_tile_company.dart';
import 'package:gurme/features/profile/widgets/profile_sliver_tab_bar.dart';
import 'package:gurme/features/profile/widgets/profile_space_app_bar.dart';
import 'package:gurme/features/profile/widgets/profile_zero_comment_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String _id;
  const ProfileScreen({super.key, required String id}) : _id = id;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  final _scrollControllerNestedView = ScrollController();
  final _scrollControllerTabViewComments = ScrollController();
  final _scrollControllerTabViewFavorites = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerNestedView.dispose();
    _scrollControllerTabViewComments.dispose();
    _scrollControllerTabViewFavorites.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ref.watch(getUserByIdProvider(widget._id)).when(
          data: (user) {
            return Scaffold(
              body: NestedScrollView(
                controller: _scrollControllerNestedView,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  ProfileBannerAppBar(
                    scrollControllerNestedView: _scrollControllerNestedView,
                    screenWidth: screenWidth,
                    ref: ref,
                    pageUserId: widget._id,
                    user: user,
                  ),
                  ProfileSpaceAppBar(screenWidth: screenWidth),
                  ProfileSilverTabBar(tabController: _tabController),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ref.watch(getCommentsOfUserProvider(widget._id)).when(
                          data: (commentData) {
                            return commentData.comments.isEmpty
                                ? ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    children: const [
                                      ZeroCommentTileProfile(),
                                    ],
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    itemCount: commentData.comments.length,
                                    itemBuilder: (context, index) {
                                      final comment =
                                          commentData.comments[index];
                                      final item = commentData.items[index];
                                      return CommentTileCompany(
                                        comment: comment,
                                        item: item,
                                      );
                                    },
                                  );
                          },
                          error: (error, stackTrace) =>
                              const NotFoundScreen(isNotFound: false),
                          loading: () => const LoadingSpinner(
                            height: 50,
                            width: 50,
                          ),
                        ),
                    ref
                        .watch(
                          getFavoriteCompaniesProvider(user.favoriteCompanyIds),
                        )
                        .when(
                          data: (companies) {
                            return companies.isEmpty
                                ? ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 10),
                                        title: Text(
                                          "En sevdiğin restoran ve kafelerini favorilemeyi unutma!",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    itemCount: companies.length,
                                    itemBuilder: (context, index) {
                                      final company = companies[index];
                                      return FavoriteTileCompany(
                                        company: company,
                                        ref: ref,
                                        user: user,
                                      );
                                    },
                                  );
                          },
                          error: (error, stackTrace) =>
                              const NotFoundScreen(isNotFound: false),
                          loading: () => const LoadingSpinner(
                            height: 50,
                            width: 50,
                          ),
                        )
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => const NotFoundScreen(isNotFound: false),
          loading: () => const Scaffold(
            body: Center(
              child: LoadingSpinner(
                width: 75,
                height: 75,
              ),
            ),
          ),
        );
  }
}
