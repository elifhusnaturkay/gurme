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
    return comments;
  }

  Future<List<UserModel>> getUsers(List<String> userIds) async {
    final usersMap = <String, UserModel>{};
    final querySnapshot = await _users.where('uid', whereIn: userIds).get();

    for (var user in querySnapshot.docs) {
      final userModel = UserModel.fromMap(user.data() as Map<String, dynamic>);
      usersMap[userModel.uid] = userModel;
    }

    final users =
        userIds.map((id) => usersMap[id]).whereType<UserModel>().toList();

    return users;
  }
}
