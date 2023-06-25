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

  Stream<List<Item>> searchItems(String query) {
    return _items
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Item> items = [];
      for (var item in event.docs) {
        items.add(Item.fromMap(item.data() as Map<String, dynamic>));
      }
      return items;
    });
  }
}
