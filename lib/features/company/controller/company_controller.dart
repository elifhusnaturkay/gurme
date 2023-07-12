import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/company/repository/company_repository.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final companyControllerProvider =
    StateNotifierProvider<CompanyController, bool>((ref) {
  return CompanyController(
      companyRepository: ref.watch(companyRepositoryProvider));
});

class CompanyData {
  final Company company;
  final List<CategoryModel> categories;
  final List<Item> popularItems;
  final List<List<Item>> items;
  CompanyData({
    required this.company,
    required this.categories,
    required this.popularItems,
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
  final popularItems = await ref
      .watch(companyControllerProvider.notifier)
      .getPopularItems(company.id);
  final items = await ref
      .watch(companyControllerProvider.notifier)
      .getAllItems(company.id, company.categoryIds);

  return CompanyData(
      company: company,
      categories: categories,
      popularItems: popularItems,
      items: items);
});

class CompanyController extends StateNotifier<bool> {
  final CompanyRepository _companyRepository;

  CompanyController({
    required CompanyRepository companyRepository,
  })  : _companyRepository = companyRepository,
        super(false);

  Future<List<Item>> getPopularItems(String companyId) async {
    return await _companyRepository.getPopularItems(companyId);
  }

  Future<Company> getCompanyById(String id) async {
    return await _companyRepository.getCompanyById(id);
  }

  Future<List<CategoryModel>> getCategories(List<String> categoryId) async {
    return await _companyRepository.getCategories(categoryId);
  }

  Future<List<List<Item>>> getAllItems(
      String companyId, List<String> categoryIds) async {
    return await _companyRepository.getAllItems(companyId, categoryIds);
  }

  Future<bool> isFavoriteCompany(String userId, String companyId) async {
    return await _companyRepository.isFavoriteCompany(userId, companyId);
  }
}
