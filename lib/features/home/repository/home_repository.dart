import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/utils/get_random_id.dart';
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

  Future<List<Item>> getPopularItems() async {
    final querySnapshot =
        await _items.orderBy('rating', descending: true).get();

    List<Item> items = [];
    for (var item in querySnapshot.docs) {
      items.add(Item.fromMap(item.data() as Map<String, dynamic>));
    }

    // Items are considered popular if their rating count is at least 20
    // To prevent display low ratingCount but high rating items
    List<Item> popularItems = [];
    for (var item in items) {
      if (popularItems.length == 5) {
        break;
      }
      if (item.ratingCount >= 20) {
        popularItems.add(item);
      }
    }
    return popularItems;
  }

  Future<List<Company>> getPopularCompanies() async {
    final querySnapshot =
        await _company.orderBy('rating', descending: true).get();

    List<Company> companies = [];
    for (var company in querySnapshot.docs) {
      companies.add(Company.fromMap(company.data() as Map<String, dynamic>));
    }

    // Companies are considered popular if their rating count is at least 50
    // To prevent display low ratingCount but high rating companies
    List<Company> popularCompanies = [];
    for (var company in companies) {
      if (popularCompanies.length == 5) {
        break;
      }
      if (company.ratingCount >= 50) {
        popularCompanies.add(company);
      }
    }
    return popularCompanies;
  }

  Future<List<CategoryModel>> getCategories() async {
    final querySnapshot = await _category.get();

    List<CategoryModel> categories = [];
    for (var category in querySnapshot.docs) {
      categories
          .add(CategoryModel.fromMap(category.data() as Map<String, dynamic>));
    }
    return categories;
  }

  Future<List<Item>> getRandomItems() async {
    List<Item> randomItems = [];
    final randomId = RandomIdGenerator.autoId();

    QuerySnapshot querySnapshot = await _items
        .where('id', isLessThanOrEqualTo: randomId)
        .orderBy('id', descending: true)
        .limit(10)
        .get();

    for (var item in querySnapshot.docs) {
      randomItems.add(Item.fromMap(item.data() as Map<String, dynamic>));
    }

    if (randomItems.length != 10) {
      final remainingItemLength = 10 - randomItems.length;
      querySnapshot = await _items
          .where('id', isGreaterThanOrEqualTo: randomId)
          .orderBy('id')
          .limit(remainingItemLength)
          .get();
      for (var item in querySnapshot.docs) {
        randomItems.add(Item.fromMap(item.data() as Map<String, dynamic>));
      }
    }

    return randomItems;
  }
}
