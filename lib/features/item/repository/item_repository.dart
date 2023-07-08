import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/comment_model.dart';
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

  Future<List<Comment>> getComments(String itemId) async {
    final querySnapshot = await _comments
        .where('itemId', isEqualTo: itemId)
        .where('text', isNull: false)
        .get();

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
            userRef: comment.userRef);
        _firestore.collection('comments').add(comment as Map<String, dynamic>);
      }
    }
    return comments;
  }
}
