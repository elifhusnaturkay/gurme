import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

final profileRepositoryProvider = Provider((ref) {
  return ProfileRepository(firestore: ref.watch(firestoreProvider));
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _company => _firestore.collection('company');
  CollectionReference get _comments => _firestore.collection('comments');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _items => _firestore.collection('items');

  Future<UserModel> getUserById(String userId) async {
    late UserModel userModel;
    await _users.doc(userId).get().then((value) {
      userModel = UserModel.fromMap(value.data() as Map<String, dynamic>);
    });

    return userModel;
  }

  Future<List<Comment>> getCommentsOfUser(String userId) async {
    final querySnapshot = await _comments
        .where('userRef', isEqualTo: userId)
        .where('text', isNull: false)
        .get();

    List<Comment> comments = [];
    for (var comment in querySnapshot.docs) {
      comments.add(Comment.fromMap(comment.data() as Map<String, dynamic>));
    }

    return comments;
  }

  Future<List<Company>> getFavoriteCompanies(
      List<String> favoriteCompanyIds) async {
    if (favoriteCompanyIds.isEmpty) {
      return [];
    }
    final querySnapshot =
        await _company.where('id', whereIn: favoriteCompanyIds).get();

    List<Company> companies = [];
    for (var company in querySnapshot.docs) {
      companies.add(Company.fromMap(company.data() as Map<String, dynamic>));
    }

    return companies;
  }

  Future<List<Item>> getItemsByIds(List<String> itemIds) async {
    List<Item> items = [];

    for (var itemId in itemIds) {
      final item = await getItemById(itemId);
      items.add(item);
    }
    return items;
  }

  Future<Item> getItemById(String itemId) async {
    late Item item;
    await _items.doc(itemId).get().then((value) {
      item = Item.fromMap(value.data() as Map<String, dynamic>);
    });

    return item;
  }

  Future<void> removeFromFavorites(String userId, String companyId) async {
    await _users.doc(userId).update({
      'favoriteCompanyIds': FieldValue.arrayRemove([companyId])
    });
  }

  Future<void> addToFavorites(String userId, String companyId) async {
    await _users.doc(userId).update({
      'favoriteCompanyIds': FieldValue.arrayUnion([companyId])
    });
  }
}
