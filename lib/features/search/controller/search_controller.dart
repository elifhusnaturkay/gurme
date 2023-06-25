import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/repository/search_repository.dart';
import 'package:gurme/models/item_model.dart';

final searchControllerProvider = StateNotifierProvider<SearchController, bool>(
  (ref) => SearchController(
    searchRepository: ref.watch(searchRepositoryProvider),
    ref: ref,
  ),
);

final searchItemProvider = StreamProvider.family(
  (ref, String query) =>
      ref.watch(searchControllerProvider.notifier).searchItem(query),
);

class SearchController extends StateNotifier<bool> {
  final SearchRepository _searchRepository;
  final Ref _ref;

  SearchController({
    required SearchRepository searchRepository,
    required Ref ref,
  })  : _searchRepository = searchRepository,
        _ref = ref,
        super(false);

  Stream<List<Item>> searchItem(String query) {
    return _searchRepository.searchItems(query);
  }
}
