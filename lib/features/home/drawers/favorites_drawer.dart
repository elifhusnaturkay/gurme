import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/home/controller/home_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoritesDrawer extends ConsumerStatefulWidget {
  const FavoritesDrawer({super.key});

  @override
  ConsumerState<FavoritesDrawer> createState() => _FavoritesDrawerState();
}

class _FavoritesDrawerState extends ConsumerState<FavoritesDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: ref.watch(userProvider.notifier).state!.isAuthenticated
                ? ListTile(
                    title: Text(
                      "Favoriler",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 10),
                        title: Text(
                          "Favori restoran ve kafelerine daha hızlı ulaşabilmek için giriş yap!",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
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
                  ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: ref
                  .watch(
                    getFavoriteCompaniesProvider(ref
                        .watch(userProvider.notifier)
                        .state!
                        .favoriteCompanyIds),
                  )
                  .when(
                      data: (companies) {
                        return companies.isEmpty &&
                                ref
                                    .watch(userProvider.notifier)
                                    .state!
                                    .isAuthenticated
                            ? [
                                ListTile(
                                  title: Text(
                                    "En sevdiğin restoran ve kafelerini favorilemeyi unutma!",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ]
                            : List.generate(
                                companies.length,
                                (index) {
                                  final company = companies[index];
                                  return ListTile(
                                    onTap: () {
                                      context.pushNamed(
                                        RouteConstants.companyScreen,
                                        pathParameters: {"id": company.id},
                                      );
                                    },
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: Image.network(
                                                  company.bannerPic,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              company.name,
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
                                                      company.rating
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
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      company.ratingCount
                                                          .toString(),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors
                                                            .grey.shade400,
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
                                                      company.commentCount
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
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        index != companies.length - 1
                                            ? const SizedBox(height: 5)
                                            : const SizedBox(),
                                        index != companies.length - 1
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        80, 0, 20, 0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                                color: Colors.grey.shade300,
                                              )
                                            : const SizedBox(height: 5),
                                      ],
                                    ),
                                  );
                                },
                              );
                      },
                      error: (error, stackTrace) => [const Text("error")],
                      loading: () => [
                            Center(
                              child: LoadingAnimationWidget.waveDots(
                                color: Colors.indigo.shade400,
                                size: 50,
                              ),
                            ),
                          ]),
            ),
          ),
        ],
      ),
    );
  }
}
