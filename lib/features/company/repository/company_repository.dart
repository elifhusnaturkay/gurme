import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final companyRepositoryProvider = Provider((ref) {
  return CompanyRepository(firestore: ref.watch(firestoreProvider));
});

class CompanyRepository {
  final FirebaseFirestore _firestore;
  CompanyRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _items => _firestore.collection('items');
  CollectionReference get _company => _firestore.collection('company');
  CollectionReference get _category => _firestore.collection('category');
  CollectionReference get _users => _firestore.collection('users');

  Future<Company> getCompanyById(String id) async {
    late Company company;
    await _company.doc(id).get().then((value) {
      company = Company.fromMap(value.data() as Map<String, dynamic>);
    });

    return company;
  }

  Future<List<CategoryModel>> getCategories(List<String> categoryIds) async {
    final categoriesMap = <String, CategoryModel>{};
    final querySnapshot =
        await _category.where('id', whereIn: categoryIds).get();

    for (var category in querySnapshot.docs) {
      final categoryModel =
          CategoryModel.fromMap(category.data() as Map<String, dynamic>);
      categoriesMap[categoryModel.id] = categoryModel;
    }

    final categories = categoryIds
        .map((id) => categoriesMap[id])
        .whereType<CategoryModel>()
        .toList();
    return categories;
  }

  Future<List<List<Item>>> getAllItems(
      String companyId, List<String> categoryIds) async {
    List<List<Item>> allItems = [];

    for (var i = 0; i < categoryIds.length; i++) {
      final itemsByCategory =
          await getItemsByCategory(companyId, categoryIds[i]);
      allItems.add(itemsByCategory);
    }
    return allItems;
  }

  Future<List<Item>> getItemsByCategory(
      String companyId, String categoryId) async {
    List<Item> items = [];

    final querySnapshot = await _items
        .where('categoryId', isEqualTo: categoryId)
        .where('companyId', isEqualTo: companyId)
        .get();

    for (var item in querySnapshot.docs) {
      items.add(Item.fromMap(item.data() as Map<String, dynamic>));
    }

    return items;
  }

  Future<List<Item>> getPopularItems(String companyId) async {
    List<Item> popularItems = [];

    final querySnapshot = await _items
        .where('companyId', isEqualTo: companyId)
        .orderBy('ratingCount', descending: true)
        .get();

    for (var item in querySnapshot.docs) {
      popularItems.add(Item.fromMap(item.data() as Map<String, dynamic>));
    }

    return popularItems;
  }

  Future<bool> isFavoriteCompany(String userId, String companyId) async {
    final querySnapshot = await _users
        .where('uid', isEqualTo: userId)
        .where('favoriteCompanyIds', arrayContains: companyId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
