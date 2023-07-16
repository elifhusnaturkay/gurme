import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gurme/common/constants/string_constants.dart';
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

  // This function returns all the comments of the Item.
  // If the current user has a comment it replaces it with the first comment in the list
  // also check user information of comment and update if its changed (such as profile picture)
  // and removes any comments with empty texts
  Stream<List<Comment>> getComments(String itemId, String userId) {
    return _comments
        .where('itemId', isEqualTo: itemId)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Comment> comments = [];
      for (var comment in querySnapshot.docs) {
        comments.add(Comment.fromMap(comment.data() as Map<String, dynamic>));
      }

      for (var i = 0; i < comments.length; i++) {
        final querySnapshot = await _users.doc(comments[i].userRef).get();
        final userData =
            UserModel.fromMap(querySnapshot.data() as Map<String, dynamic>);
        if (comments[i].user != userData) {
          comments[i] = comments[i].copyWith(
            user: userData,
          );
          await _comments.doc(comments[i].id).update(comments[i].toMap());
        }
        if (comments[i].userRef == userId) {
          if (i != 0) {
            var temp = comments[0];
            comments[0] = comments[i];
            comments[i] = temp;
          }
        }
        if (comments[i].text == null && comments[i].userRef != userId) {
          comments.remove(comments[i]);
          i--;
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
        text: null,
      );
    } else {
      comment = Comment(
        user: user,
        id: commentId,
        itemId: item.id,
        rating: rating,
        userRef: user.uid,
        text: text,
      );
    }

    try {
      await updateItem(null, item, rating, isCommentEmpty);
      await updateCompany(null, item.companyId, rating, isCommentEmpty);
      await _comments.doc(commentId).set(comment.toMap());
      return right(null);
    } catch (e) {
      return left(ErrorMessageConstants.commentError);
    }
  }

  FutureEither<void> updateComment(
      Comment comment, Item item, int rating, String text) async {
    late Comment updatedComment;
    final bool isCommentEmpty = !RegExp(r'\S').hasMatch(text);

    // if text has only whitespace characters
    if (isCommentEmpty) {
      updatedComment = comment.copyWithNull(rating: rating, text: null);
    } else {
      updatedComment = comment.copyWith(rating: rating, text: text);
    }

    try {
      await updateItem(comment, item, rating, isCommentEmpty);
      await updateCompany(comment, item.companyId, rating, isCommentEmpty);
      await _comments.doc(comment.id).update(updatedComment.toMap());
      return right(null);
    } catch (e) {
      return left(ErrorMessageConstants.commentError);
    }
  }

  Future<void> updateCompany(
    Comment? oldComment,
    String companyId,
    int rating,
    bool isCommentEmpty,
  ) async {
    late Company company;
    await _company.doc(companyId).get().then((value) {
      company = Company.fromMap(value.data() as Map<String, dynamic>);
    });
    double newCompanyRating = company.rating;

    if (oldComment == null) {
      final sumOfItemRating = company.ratingCount * company.rating;
      newCompanyRating = (sumOfItemRating + rating) / (company.ratingCount + 1);
    } else if (oldComment.rating != rating) {
      final sumOfItemRating = company.ratingCount * company.rating;
      newCompanyRating = (sumOfItemRating + (rating - oldComment.rating)) /
          company.ratingCount;
    }

    late Company updatedCompany;
    if (oldComment == null) {
      if (isCommentEmpty) {
        updatedCompany = company.copyWith(
          rating: newCompanyRating,
          ratingCount: company.ratingCount + 1,
        );
      } else {
        updatedCompany = company.copyWith(
          commentCount: company.commentCount + 1,
          rating: newCompanyRating,
          ratingCount: company.ratingCount + 1,
        );
      }
    } else {
      if (oldComment.text == null) {
        if (isCommentEmpty) {
          updatedCompany = company.copyWith(
            rating: newCompanyRating,
          );
        } else {
          updatedCompany = company.copyWith(
            commentCount: company.commentCount + 1,
            rating: newCompanyRating,
          );
        }
      } else {
        if (isCommentEmpty) {
          updatedCompany = company.copyWith(
            commentCount: company.commentCount - 1,
            rating: newCompanyRating,
          );
        } else {
          updatedCompany = company.copyWith(
            rating: newCompanyRating,
          );
        }
      }
    }

    await _company.doc(companyId).update(updatedCompany.toMap());
  }

  Future<void> updateItem(
    Comment? oldComment,
    Item item,
    int rating,
    bool isCommentEmpty,
  ) async {
    double newItemRating = item.rating;

    if (oldComment == null) {
      final sumOfItemRating = item.ratingCount * item.rating;
      newItemRating = (sumOfItemRating + rating) / (item.ratingCount + 1);
    } else if (oldComment.rating != rating) {
      final sumOfItemRating = item.ratingCount * item.rating;
      newItemRating =
          (sumOfItemRating + (rating - oldComment.rating)) / item.ratingCount;
    }

    late Item updatedItem;
    if (oldComment == null) {
      if (isCommentEmpty) {
        updatedItem = item.copyWith(
          rating: newItemRating,
          ratingCount: item.ratingCount + 1,
        );
      } else {
        updatedItem = item.copyWith(
          commentCount: item.commentCount + 1,
          rating: newItemRating,
          ratingCount: item.ratingCount + 1,
        );
      }
    } else {
      if (oldComment.text == null) {
        if (isCommentEmpty) {
          updatedItem = item.copyWith(
            rating: newItemRating,
          );
        } else {
          updatedItem = item.copyWith(
            commentCount: item.commentCount + 1,
            rating: newItemRating,
          );
        }
      } else {
        if (isCommentEmpty) {
          updatedItem = item.copyWith(
            commentCount: item.commentCount - 1,
            rating: newItemRating,
          );
        } else {
          updatedItem = item.copyWith(
            rating: newItemRating,
          );
        }
      }
    }

    await _items.doc(item.id).update(updatedItem.toMap());
  }

  Future<void> deleteUpdateItem(
    Comment oldComment,
    Item item,
  ) async {
    final double newItemRating;

    final sumOfItemRating = item.ratingCount * item.rating;
    newItemRating =
        (sumOfItemRating - oldComment.rating) / (item.ratingCount - 1);

    late Item updatedItem;

    if (oldComment.text == null) {
      updatedItem = item.copyWith(
        commentCount: item.commentCount,
        rating: newItemRating,
        ratingCount: item.ratingCount - 1,
      );
    } else {
      updatedItem = item.copyWith(
        commentCount: item.commentCount - 1,
        rating: newItemRating,
        ratingCount: item.ratingCount - 1,
      );
    }

    await _items.doc(item.id).update(updatedItem.toMap());
  }

  Future<void> deleteUpdateCompany(
    Comment oldComment,
    String companyId,
  ) async {
    late Company company;
    await _company.doc(companyId).get().then((value) {
      company = Company.fromMap(value.data() as Map<String, dynamic>);
    });
    final double newCompanyRating;

    final sumOfItemRating = company.ratingCount * company.rating;
    newCompanyRating =
        (sumOfItemRating - oldComment.rating) / (company.ratingCount - 1);

    late Company updatedCompany;

    if (oldComment.text == null) {
      updatedCompany = company.copyWith(
        commentCount: company.commentCount,
        rating: newCompanyRating,
        ratingCount: company.ratingCount - 1,
      );
    } else {
      updatedCompany = company.copyWith(
        commentCount: company.commentCount - 1,
        rating: newCompanyRating,
        ratingCount: company.ratingCount - 1,
      );
    }

    await _items.doc(company.id).update(updatedCompany.toMap());
  }

  FutureEither<void> deleteComment(
      String commentId, Comment oldComment, Item item) async {
    try {
      await _comments.doc(commentId).delete();
      await deleteUpdateCompany(oldComment, item.companyId);
      await deleteUpdateItem(oldComment, item);
      return right(null);
    } catch (e) {
      return left(ErrorMessageConstants.commentDeleteError);
    }
  }
}
