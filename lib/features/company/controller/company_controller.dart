import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/company/repository/company_repository.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final companyControllerProvider =
    StateNotifierProvider<CompanyController, bool>((ref) {
  return CompanyController(
      comapanyRepository: ref.watch(companyRepositoryProvider));
});

final getPoularItemsProvider =
    StreamProvider.family.autoDispose((ref, String companyId) {
  return ref
      .watch(companyControllerProvider.notifier)
      .getPopularItems(companyId);
});

class CompanyData {
  final Company company;
  final List<CategoryModel> categories;
  final List<List<Item>> items;

  CompanyData({
    required this.company,
    required this.categories,
    required this.items,
  });
}

final companyDataProvider = FutureProvider.family
    .autoDispose<CompanyData, String>((ref, String id) async {
  final company =
      await ref.watch(companyControllerProvider.notifier).getCompanyById(id);
  final categories = await ref
      .watch(companyControllerProvider.notifier)
      .getCategories(company.categoryIds);
  final items = await ref
      .watch(companyControllerProvider.notifier)
      .getAllItems(company.id, company.categoryIds);

  return CompanyData(company: company, categories: categories, items: items);
});

class CompanyController extends StateNotifier<bool> {
  final CompanyRepository _comapanyRepository;

  CompanyController({
    required CompanyRepository comapanyRepository,
  })  : _comapanyRepository = comapanyRepository,
        super(false);

  Stream<List<Item>> getPopularItems(String companyId) {
    return _comapanyRepository.getPopularItems(companyId);
  }

  Future<Company> getCompanyById(String id) async {
    return await _comapanyRepository.getCompanyById(id);
  }

  Future<List<CategoryModel>> getCategories(List<String> categoryId) async {
    return await _comapanyRepository.getCategories(categoryId);
  }

  Future<List<List<Item>>> getAllItems(
      String companyId, List<String> categoryIds) async {
    return await _comapanyRepository.getAllItems(companyId, categoryIds);
  }
}
