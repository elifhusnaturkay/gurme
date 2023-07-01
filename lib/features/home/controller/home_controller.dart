import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/home/repository/home_repository.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(homeRepository: ref.watch(homeRepositoryProvider));
});

final getPopularItemsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getPopularItems();
});

final getPopularCompaniesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getPopularCompanies();
});

final getCategoriesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getCategories();
});

class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository;

  HomeController({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(false);

  Stream<List<Item>> getPopularItems() {
    return _homeRepository.getPopularItems();
  }

  Stream<List<Company>> getPopularCompanies() {
    return _homeRepository.getPopularCompanies();
  }

  Stream<List<CategoryModel>> getCategories() {
    return _homeRepository.getCategories();
  }
}
