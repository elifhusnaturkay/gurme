import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

final searchRepositoryProvider = Provider((ref) {
  return SearchRepository(firestore: ref.watch(firestoreProvider));
});

class SearchRepository {
  final FirebaseFirestore _firestore;
  SearchRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _items => _firestore.collection('items');
  CollectionReference get _company => _firestore.collection('company');

  Stream<List<Item>> searchItems(String? query) {
    if (query == null || query.isEmpty) {
      return Stream.value([]);
    }

    String lowercaseQuery = query.toLowerCase();

    return _items
        .where('lowercaseName', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('lowercaseName', isLessThanOrEqualTo: '$lowercaseQuery\uf8ff')
        .snapshots()
        .map((event) {
      List<Item> items = [];
      for (var item in event.docs) {
        items.add(Item.fromMap(item.data() as Map<String, dynamic>));
      }
      return items;
    });
  }

  Stream<List<Company>> searchCompanies(String? query) {
    if (query == null || query.isEmpty) {
      return Stream.value([]);
    }

    String lowercaseQuery = query.toLowerCase();

    return _company
        .where('lowercaseName', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('lowercaseName', isLessThanOrEqualTo: '$lowercaseQuery\uf8ff')
        .snapshots()
        .map((event) {
      List<Company> companies = [];
      for (var company in event.docs) {
        companies.add(Company.fromMap(company.data() as Map<String, dynamic>));
      }
      return companies;
    });
  }

  Future<List<Item>> getItemsByCategory(String categoryId) async {
    List<Item> items = [];
    final querySnapshot =
        await _items.where('categoryId', isEqualTo: categoryId).get();

    for (var item in querySnapshot.docs) {
      items.add(Item.fromMap(item.data() as Map<String, dynamic>));
    }

    return items;
  }
}
