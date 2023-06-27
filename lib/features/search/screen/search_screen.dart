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
            TextButton(onPressed: () {}, child: const Text('ürün')),
            const Text('/'),
            TextButton(onPressed: () {}, child: const Text('restoran')),
          ],
          backgroundColor: const Color.fromRGBO(246, 246, 246, 0.5),
        ),
        body: ref.watch(searchItemProvider(searchController.text)).when(
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
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}
