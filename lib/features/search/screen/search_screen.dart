import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/controller/search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // final queryProvider = StateProvider<String?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    final isSearchingItems = ref.watch(isSearchingItemsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Bugün canın ne çekiyor?',
            ),
            onChanged: (value) {
              ref.read(queryProvider.notifier).update((state) => value);
            },
          ),
          actions: [
            GestureDetector(
              child: Text(
                'ürün',
                style: TextStyle(
                    color: isSearchingItems ? Colors.blue : Colors.white),
              ),
              onTap: () {
                if (!isSearchingItems) {
                  ref
                      .read(isSearchingItemsProvider.notifier)
                      .update((state) => !state);
                }
              },
            ),
            const Text('/'),
            GestureDetector(
              child: Text(
                'restoran',
                style: TextStyle(
                    color: isSearchingItems ? Colors.white : Colors.blue),
              ),
              onTap: () {
                if (isSearchingItems) {
                  ref
                      .read(isSearchingItemsProvider.notifier)
                      .update((state) => !state);
                }
              },
            ),
          ],
          backgroundColor: const Color.fromRGBO(246, 246, 246, 0.5),
        ),
        body: isSearchingItems
            ? ref.watch(searchItemProvider).when(
                  data: (items) {
                    if (items.isEmpty && searchController.text.length > 3) {
                      return const Center(
                        child: Text('No suggestions found.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.name),
                          // TODO: add popup or navigate to restaurants
                          onTap: () {},
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
      ),
    );
  }
}
