import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/search/repository/search_repository.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final searchControllerProvider = StateNotifierProvider<SearchController, bool>(
  (ref) => SearchController(
    searchRepository: ref.watch(searchRepositoryProvider),
    ref: ref,
  ),
);

final queryProvider = StateProvider.autoDispose<String?>((ref) => null);
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedCategoryIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final searchItemProvider = StreamProvider.autoDispose((ref) {
  final searchText = ref.watch(queryProvider);

  return ref.watch(searchControllerProvider.notifier).searchItem(searchText);
});

final searchCompanyProvider = StreamProvider.autoDispose((ref) {
  final searchText = ref.watch(queryProvider);

  return ref
      .watch(searchControllerProvider.notifier)
      .searchCompanies(searchText);
});

final getItemsByCategoryProvider =
    FutureProvider.autoDispose.family((ref, String categoryId) {
  return ref
      .watch(searchControllerProvider.notifier)
      .getItemsByCategory(categoryId);
});

class SearchController extends StateNotifier<bool> {
  final SearchRepository _searchRepository;

  SearchController({
    required SearchRepository searchRepository,
    required Ref ref,
  })  : _searchRepository = searchRepository,
        super(false);

  Stream<List<Item>> searchItem(String? query) {
    return _searchRepository.searchItems(query);
  }

  Stream<List<Company>> searchCompanies(String? query) {
    return _searchRepository.searchCompanies(query);
  }

  Future<List<Item>> getItemsByCategory(String categoryId) async {
    return await _searchRepository.getItemsByCategory(categoryId);
  }
}
