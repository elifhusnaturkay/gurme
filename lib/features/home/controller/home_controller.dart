import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/home/repository/home_repository.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(homeRepository: ref.watch(homeRepositoryProvider));
});

final getPopularItemsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getPopularItems();
});

final getPopularCompaniesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getPopularCompanies();
});

final getCategoriesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getCategories();
});

final getRandomItemsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(homeControllerProvider.notifier).getRandomItems();
});

class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository;

  HomeController({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(false);

  Future<List<Item>> getPopularItems() async {
    return await _homeRepository.getPopularItems();
  }

  Future<List<Company>> getPopularCompanies() async {
    return await _homeRepository.getPopularCompanies();
  }

  Future<List<CategoryModel>> getCategories() async {
    return await _homeRepository.getCategories();
  }

  Future<List<Item>> getRandomItems() async {
    return await _homeRepository.getRandomItems();
  }
}
