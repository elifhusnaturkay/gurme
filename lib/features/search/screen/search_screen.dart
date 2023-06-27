import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/screen/search_screen_delegate.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final delegate = SearchScreenDelegate(ref);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: const Text('Gurme'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: delegate);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
        backgroundColor: Colors.indigo.shade400,
      ),
    ));
  }
}
