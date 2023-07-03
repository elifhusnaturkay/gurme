import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/features/search/controller/search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

void loseFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
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
      begin: Colors.indigo.shade400,
      end: const Color.fromRGBO(92, 107, 192, 0.5),
    ).animate(_animationController);

    _colorAnimationCompany = ColorTween(
      begin: const Color.fromRGBO(92, 107, 192, 0.5),
      end: Colors.indigo.shade400,
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

  // final queryProvider = StateProvider<String?>((ref) => null);

  @override
  Widget build(BuildContext context) {
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
                  leadingWidth: 20,
                  iconTheme: const IconThemeData(
                    color: Colors.black,
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
                  centerTitle: true,
                  elevation: 0,
                  title: SizedBox(
                    width: 200,
                    child: TextField(
                      controller: searchController,
                      cursorColor: Colors.indigo.shade400,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bugün canın ne çekiyor?',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15,
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
                        child: Text('No suggestions found.'),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = items[index];
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
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
                                          item.name,
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
                                                  item.rating.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                  item.ratingCount.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey.shade400,
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
                                                  item.commentCount.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.chat_rounded,
                                                  color: Colors.indigo.shade400,
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
                                    index != items.length - 1
                                        ? const SizedBox(height: 15)
                                        : const SizedBox(),
                                    index != items.length - 1
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
                                  ],
                                ),
                                // TODO: add popup or navigate to restaurants
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            : ref.watch(searchCompanyProvider).when(
                  data: (companies) {
                    if (companies.isEmpty && searchController.text.length > 3) {
                      return const Center(
                        child: Text('No suggestions found.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final company = companies[index];
                        return ListTile(
                          title: Text(company.name),
                          // TODO: navigate to restaurants
                          onTap: () {},
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
      ),
    );
  }
}
