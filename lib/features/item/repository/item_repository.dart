import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gurme/common/utils/get_random_id.dart';
import 'package:gurme/common/utils/type_defs.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

final itemRepositoryProvider = Provider((ref) {
  return ItemRepository(firestore: ref.watch(firestoreProvider));
});

class ItemRepository {
  final FirebaseFirestore _firestore;
  ItemRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _comments => _firestore.collection('comments');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _items => _firestore.collection('items');
  CollectionReference get _company => _firestore.collection('company');

  Stream<List<Comment>> getComments(String itemId) {
    return _comments
        .where('itemId', isEqualTo: itemId)
        .where('text', isNull: false)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Comment> comments = [];
      for (var comment in querySnapshot.docs) {
        comments.add(Comment.fromMap(comment.data() as Map<String, dynamic>));
      }

      for (var comment in comments) {
        final querySnapshot = await _users.doc(comment.userRef).get();
        final userData =
            UserModel.fromMap(querySnapshot.data() as Map<String, dynamic>);
        if (comment.user != userData) {
          comment = comment.copyWith(
            id: comment.id,
            user: userData,
            itemId: comment.itemId,
            rating: comment.rating,
            text: comment.text,
            userRef: comment.userRef,
          );
          await _comments.doc(comment.id).update(comment.toMap());
        }
      }

      return comments;
    });
  }

  FutureEither<void> sendComment(
      UserModel user, Item item, int rating, String text) async {
    final String commentId = RandomIdGenerator.autoId();
    late Comment comment;

    final bool isCommentEmpty = !RegExp(r'\S').hasMatch(text);

    // if text has only whitespace characters
    if (isCommentEmpty) {
      comment = Comment(
          user: user,
          id: commentId,
          itemId: item.id,
          rating: rating,
          userRef: user.uid,
          text: null);
    } else {
      comment = Comment(
          user: user,
          id: commentId,
          itemId: item.id,
          rating: rating,
          userRef: user.uid,
          text: text);
    }

    try {
      await updateItem(item, rating, isCommentEmpty);
      await updateCompany(item.companyId, rating, isCommentEmpty);
      return right(_comments.doc(commentId).set(comment.toMap()));
    } catch (e) {
      return left('Yorum gönderilirken bir şeyler ters gitti');
    }
  }

  Future<void> updateCompany(
      String companyId, int rating, bool isCommentEmpty) async {
    late Company company;
    await _company.doc(companyId).get().then((value) {
      company = Company.fromMap(value.data() as Map<String, dynamic>);
    });

    // update rating
    final sumOfCompanyRating = company.ratingCount * company.rating;
    final newCompanyRating =
        (sumOfCompanyRating + rating) / (company.ratingCount + 1);

    late Company updatedCompany;
    if (isCommentEmpty) {
      updatedCompany = company.copyWith(
          id: company.id,
          bannerPic: company.bannerPic,
          categoryIds: company.categoryIds,
          commentCount: company.commentCount,
          lowercaseName: company.lowercaseName,
          name: company.name,
          location: company.location,
          rating: newCompanyRating,
          ratingCount: company.ratingCount + 1);
    } else {
      updatedCompany = company.copyWith(
          id: company.id,
          bannerPic: company.bannerPic,
          categoryIds: company.categoryIds,
          commentCount: company.commentCount + 1,
          lowercaseName: company.lowercaseName,
          name: company.name,
          location: company.location,
          rating: newCompanyRating,
          ratingCount: company.ratingCount + 1);
    }

    await _company.doc(companyId).update(updatedCompany.toMap());
  }

  Future<void> updateItem(Item item, int rating, bool isCommentEmpty) async {
    final sumOfItemRating = item.ratingCount * item.rating;
    final newItemRating = (sumOfItemRating + rating) / (item.ratingCount + 1);
    late Item updatedItem;
    if (isCommentEmpty) {
      updatedItem = item.copyWith(
          id: item.id,
          categoryId: item.categoryId,
          categoryName: item.categoryName,
          companyId: item.companyId,
          companyName: item.companyName,
          picture: item.picture,
          commentCount: item.commentCount,
          lowercaseName: item.lowercaseName,
          name: item.name,
          location: item.location,
          rating: newItemRating,
          ratingCount: item.ratingCount + 1);
    } else {
      updatedItem = item.copyWith(
          id: item.id,
          categoryId: item.categoryId,
          categoryName: item.categoryName,
          companyId: item.companyId,
          companyName: item.companyName,
          picture: item.picture,
          commentCount: item.commentCount + 1,
          lowercaseName: item.lowercaseName,
          name: item.name,
          location: item.location,
          rating: newItemRating,
          ratingCount: item.ratingCount + 1);
    }

    await _items.doc(item.id).update(updatedItem.toMap());
  }
}
