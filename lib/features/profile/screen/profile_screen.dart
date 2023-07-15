import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

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
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    collapsedHeight: 60,
                    toolbarHeight: 60,
                    expandedHeight: 150,
                    pinned: true,
                    automaticallyImplyLeading: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        // scroll offset to 0.0 - 1.0
                        final double ratio =
                            (_scrollControllerNestedView.offset /
                                    (150 - kToolbarHeight))
                                .clamp(0, 1);

                        // sliverappbar color animation
                        final backgroundColor = Color.lerp(
                          const Color(0xFFCFD3ED).withOpacity(0.00),
                          const Color(0xFFCFD3ED).withOpacity(1),
                          ratio,
                        );

                        final textAlignment = AlignmentTween(
                          begin: Alignment.center,
                          end: Alignment.centerLeft,
                        ).transform(ratio);

                        // profile pic animation
                        final imageRadius =
                            80 - (25 * ratio) + ((screenWidth - 393) * 0.1);
                        final imagePositionBottom =
                            (-55) - (25 * ratio) - ((screenWidth - 393) * 0.2);
                        final imagePositionLeft = (screenWidth * 0.5 - 80) -
                            ((screenWidth * 0.5 - 105) * ratio);
                        final iconColor = Color.lerp(
                          Colors.black,
                          Theme.of(context).canvasColor,
                          ratio,
                        );

                        // icon animation
                        final iconPositionBottom = 50 - (45 * ratio);
                        final iconPositionLeft = (screenWidth * 0.5 + 40) +
                            ((screenWidth * 0.4 - 50) * ratio);

                        // name animation
                        final namePositionLeft =
                            (((screenWidth - 393) * 0.2 + 147) * ratio);
                        final namePositionTop = 220 -
                            ((150 + ((screenWidth - 393) * 0.2)) * ratio) +
                            ((screenWidth - 393) * 0.2);

                        // font size
                        final fontSize =
                            32 + ((screenWidth - 393) * 0.1) - (10 * ratio);

                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.bannerPic,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: backgroundColor,
                              ),
                            ),
                            Positioned(
                              top: namePositionTop,
                              left: namePositionLeft,
                              right: 0,
                              child: Align(
                                alignment: textAlignment,
                                child: SafeArea(
                                  child: SizedBox(
                                    child: Text(
                                      user.name,
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                      style: GoogleFonts.inter(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: imagePositionBottom,
                              left: imagePositionLeft,
                              child: Hero(
                                tag: "profiletoedit",
                                child: Container(
                                  height: imageRadius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFCFD3ED),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: imageRadius,
                                    backgroundColor:
                                        Colors.indigo.shade400.withOpacity(0.2),
                                    backgroundImage: NetworkImage(
                                      user.profilePic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ref.watch(userProvider.notifier).state!.uid ==
                                    widget._id
                                ? Positioned(
                                    bottom: iconPositionBottom,
                                    left: iconPositionLeft,
                                    child: Container(
                                      width: 50 + ((screenWidth - 393) * 0.1),
                                      height: 50 + ((screenWidth - 393) * 0.1),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withOpacity(1 - ratio),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Colors.black.withOpacity(
                                                0.25 - 0.25 * ratio),
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          context.pushNamed(
                                              RouteConstants.editProfileScreen);
                                        },
                                        iconSize:
                                            30 + ((screenWidth - 393) * 0.1),
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: iconColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).canvasColor,
                    expandedHeight: 120 + ((screenWidth - 393) * 0.3),
                    collapsedHeight: 60 + ((screenWidth - 393) * 0.3),
                    toolbarHeight: 60 + ((screenWidth - 393) * 0.3),
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: Container(
                      height: 120 + ((screenWidth - 393) * 0.3),
                      width: screenWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 0,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        indicatorColor: Colors.indigo.shade400,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: ["Yorumlar", "Favoriler"]
                            .map(
                              (category) => Tab(
                                text: category,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    pinned: true,
                  ),
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
                          error: (error, stackTrace) {
                            return Text(error.toString());
                          },
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
                            return ref
                                    .watch(userProvider.notifier)
                                    .state!
                                    .isAuthenticated
                                ? ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 10),
                                        title: Text(
                                          "Favori restoran ve kafelerine daha hızlı ulaşabilmek için giriş yap!",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : companies.isEmpty
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
                          error: (error, stackTrace) {
                            return Text(error.toString());
                          },
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
          error: (error, stackTrace) => Center(child: Text(error.toString())),
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

class ZeroCommentTileProfile extends StatelessWidget {
  const ZeroCommentTileProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo.shade400.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: GestureDetector(
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: GestureDetector(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: Image.asset(
                                  AssetConstants.shortLogoPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gurme',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                ),
                                child: SizedBox(
                                  child: Text(
                                    "Hiç yorumun yok! Hadi favorilerini diğer insanlarla paylaş!",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentTileCompany extends StatelessWidget {
  final Comment comment;
  final Item item;
  const CommentTileCompany(
      {super.key, required this.comment, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo.shade400.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: GestureDetector(
                  onTap: () {
                    showPopUpScreen(
                      context: context,
                      builder: (context) {
                        return CommentBottomSheet(
                          comment: comment,
                        );
                      },
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: GestureDetector(
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
                                  item.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.companyName} - ${item.name}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                comment.rating,
                                (index) => const Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                ),
                                child: SizedBox(
                                  child: Text(
                                    comment.text!,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteTileCompany extends StatefulWidget {
  final Company company;
  final WidgetRef ref;
  final UserModel user;
  const FavoriteTileCompany({
    super.key,
    required this.company,
    required this.ref,
    required this.user,
  });

  @override
  State<FavoriteTileCompany> createState() => _FavoriteTileCompanyState();
}

class _FavoriteTileCompanyState extends State<FavoriteTileCompany>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo.shade400.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.companyScreen,
                      pathParameters: {"id": widget.company.id},
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: Container(
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
                                widget.company.bannerPic,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.company.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                Text(
                                  widget.company.rating.toStringAsFixed(1),
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
                                  widget.company.ratingCount.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            if (widget.ref
                                    .read(userProvider.notifier)
                                    .state!
                                    .uid ==
                                widget.user.uid) {
                              setState(() {
                                favorite = !favorite;
                              });
                              if (!favorite) {
                                await widget.ref
                                    .read(profileControllerProvider.notifier)
                                    .removeFromFavorites(
                                        widget.user, widget.company.id);
                              } else {
                                await widget.ref
                                    .read(profileControllerProvider.notifier)
                                    .addToFavorites(
                                        widget.user, widget.company.id);
                              }
                            }
                          },
                          icon: widget.ref
                                      .watch(userProvider.notifier)
                                      .state!
                                      .uid ==
                                  widget.user.uid
                              ? favorite
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.indigo.shade400,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.indigo.shade400,
                                    )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border(
          top: BorderSide(
            width: 0,
            color: Theme.of(context).canvasColor,
          ),
        ),
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
