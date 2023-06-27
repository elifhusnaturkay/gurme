import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/controller/search_controller.dart';
import 'package:gurme/models/item_model.dart';

class SearchScreenDelegate extends SearchDelegate {
  final WidgetRef ref;

  List<Item> searchResults = [];
  SearchScreenDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      TextButton(onPressed: () {}, child: const Text('Ürün')),
      const Text('/'),
      TextButton(onPressed: () {}, child: const Text('Restoran')),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index];
        return ListTile(
          title: Text(item.name),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return ref.watch(searchItemProvider(query)).when(
        data: (items) {
          if (items.isEmpty && query.length > 3) {
            return const Center(
              child: Text('No suggestions found.'),
            );
          }

          searchResults = items;

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
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
