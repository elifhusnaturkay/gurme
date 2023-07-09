import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollControllerNestedView,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            collapsedHeight: 60,
            toolbarHeight: 60,
            expandedHeight: 150,
            pinned: true,
            automaticallyImplyLeading: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // scroll offset to 0.0 - 1.0
                final double ratio = (_scrollControllerNestedView.offset /
                        (150 - kToolbarHeight))
                    .clamp(0, 1);

                print(screenWidth);
                print(screenHeight);

                // sliverappbar color animation
                final backgroundColor = Color.lerp(
                  const Color(0xFFCFD3ED).withOpacity(0.00),
                  const Color(0xFFCFD3ED).withOpacity(1),
                  ratio,
                );

                // profile pic animation
                final imageRadius = 80 - (25 * ratio);
                final imagePositionBottom =
                    (-55 - ((screenHeight - 760) * 0.1)) - (20 * ratio);
                final imagePositionLeft = (screenWidth * 0.5 - 80) -
                    ((screenWidth * 0.5 - 100) * ratio);

                // icon animation
                final iconPositionBottom = 50 - (50 * ratio);
                final iconPositionLeft = (screenWidth * 0.5 + 40) +
                    ((screenWidth * 0.4 - 55) * ratio);

                // name animation
                final namePositionBottom = -110 + (65 * ratio);
                final namePositionLeft =
                    (screenWidth * 0.5) + ((screenWidth * 0.1 + 10) * ratio);

                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        AssetConstants.defaultBannerPic,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: backgroundColor,
                      ),
                    ),
                    Positioned(
                      bottom: namePositionBottom,
                      left: namePositionLeft,
                      child: FractionalTranslation(
                        translation: const Offset(-0.45, 0),
                        child: SizedBox(
                          width: screenWidth * 0.60,
                          child: Text(
                            "Ahmet Özcan",
                            style: GoogleFonts.inter(
                              fontSize: 32 + ((screenWidth - 393) * 0.1),
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: imagePositionBottom,
                      left: imagePositionLeft,
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
                        child: ClipOval(
                          child: Image.network(
                            AssetConstants.defaultProfilePic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: iconPositionBottom,
                      left: iconPositionLeft,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1 - ratio),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color:
                                  Colors.black.withOpacity(0.25 - 0.25 * ratio),
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            print("object");
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverAppBar(
            backgroundColor: Theme.of(context).canvasColor,
            expandedHeight: 100,
            collapsedHeight: 100,
            toolbarHeight: 100,
            pinned: true,
            elevation: 0,
            title: const SizedBox(height: 100),
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
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              itemCount: 50,
              itemBuilder: (context, index) {
                return const CommentTileCompany();
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              itemCount: 50,
              itemBuilder: (context, index) {
                return const FavoriteTileCompany();
              },
            )
          ],
        ),
      ),
    );
  }
}

class CommentTileCompany extends StatelessWidget {
  const CommentTileCompany({super.key});

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
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Commentleri çektikten sonra açılması gerek
                    /* showPopUpScreen(
                      context: context,
                      builder: (context) {
                        return CommentBottomSheet(
                          comment: comment,
                        );
                      },
                    ); */
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
                              // TODO: User Screen Navigation
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
                                  AssetConstants.defaultBannerPic,
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
                              "Company Name - İtem Name",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                2,
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
                                    "comment.text!", // cant be null
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

class FavoriteTileCompany extends StatelessWidget {
  const FavoriteTileCompany({super.key});

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
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Companye navigate
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
                                AssetConstants.defaultBannerPic,
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
                              "Company Name",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              // TODO: Yıldızlar Düzeltilicek
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                5,
                                (index) => const Rating(
                                  size: 20,
                                  stopPosition: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          //TODO: Favori Takibi Çıkartma blah blah
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_rounded),
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

class Rating extends StatelessWidget {
  const Rating({super.key, required this.size, required this.stopPosition});

  final double size;
  final double stopPosition;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect rect) {
            final gradientWidth = rect.width * stopPosition;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0, stopPosition, stopPosition],
              colors: [
                Colors.amber,
                Colors.amber,
                Colors.grey.shade300,
              ],
              tileMode: TileMode.clamp,
            ).createShader(Rect.fromLTRB(
              rect.left,
              rect.top,
              rect.left + gradientWidth + size / 2,
              rect.bottom,
            ));
          },
          child: SizedBox(
            width: size,
            height: size,
            child:
                Icon(Icons.grade_rounded, size: size, color: Colors.grey[300]),
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
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 6,
          ),
        ],
        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
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
