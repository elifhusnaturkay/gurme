import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/controller/search_controller.dart';

class SearchScreenDelegate extends SearchDelegate {
  final WidgetRef ref;
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
    return Expanded(child: SizedBox());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return ref.watch(searchItemProvider(query)).when(
          data: (items) => ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    // TODO: add popup or navigate to restaurants
                    onTap: () {},
                  );
                },
              ),
          error: (error, stackTrace) => Text("error"),
          loading: () => CircularProgressIndicator());
    }
    return Text('');
  }
}
