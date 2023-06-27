import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/repository/search_repository.dart';
import 'package:gurme/models/item_model.dart';

final searchControllerProvider = StateNotifierProvider<SearchController, bool>(
  (ref) => SearchController(
    searchRepository: ref.watch(searchRepositoryProvider),
    ref: ref,
  ),
);

final queryProvider = StateProvider<String?>((ref) => null);

final searchItemProvider =
    StreamProvider.autoDispose.family((ref, String query) {
  final searchText = ref.watch(queryProvider);
  return ref.watch(searchControllerProvider.notifier).searchItem(searchText);
});

class SearchController extends StateNotifier<bool> {
  final SearchRepository _searchRepository;
  final Ref _ref;

  SearchController({
    required SearchRepository searchRepository,
    required Ref ref,
  })  : _searchRepository = searchRepository,
        _ref = ref,
        super(false);

  Stream<List<Item>> searchItem(String? query) {
    return _searchRepository.searchItems(query);
  }
}
