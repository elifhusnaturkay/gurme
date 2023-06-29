import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/category_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository(firestore: ref.watch(firestoreProvider));
});

class HomeRepository {
  final FirebaseFirestore _firestore;
  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _items => _firestore.collection('items');
  CollectionReference get _company => _firestore.collection('company');
  CollectionReference get _category => _firestore.collection('category');

  Stream<List<Item>> getPopularItems() {
    return _items
        .orderBy('ratingCount', descending: true)
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((event) {
      List<Item> items = [];
      for (var item in event.docs) {
        items.add(Item.fromMap(item.data() as Map<String, dynamic>));
      }
      return items;
    });
  }

  Stream<List<Company>> getPopularCompanies() {
    return _company
        .orderBy('ratingCount', descending: true)
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((event) {
      List<Company> companies = [];
      for (var company in event.docs) {
        companies.add(Company.fromMap(company.data() as Map<String, dynamic>));
      }
      return companies;
    });
  }

  Stream<List<CategoryModel>> getCategories() {
    return _category.snapshots().map((event) {
      List<CategoryModel> categories = [];
      for (var category in event.docs) {
        categories.add(
            CategoryModel.fromMap(category.data() as Map<String, dynamic>));
      }
      return categories;
    });
  }
}
