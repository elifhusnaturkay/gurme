import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/features/item/repository/item_repository.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/user_model.dart';

final itemControllerProvider =
    StateNotifierProvider<ItemController, bool>((ref) {
  return ItemController(itemRepository: ref.watch(itemRepositoryProvider));
});

class CommentData {
  final List<Comment> comments;
  final List<UserModel> users;

  CommentData({required this.comments, required this.users});
}

final commentDataProvider = FutureProvider.family
    .autoDispose<CommentData, String>((ref, String id) async {
  final comments =
      await ref.watch(itemControllerProvider.notifier).getComments(id);

  List<String> userIds = [];
  for (var comment in comments) {
    userIds.add(comment.userId);
  }
  final users =
      await ref.watch(itemControllerProvider.notifier).getUsers(userIds);
  return CommentData(comments: comments, users: users);
});

class ItemController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;

  ItemController({required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(false);

  Future<List<Comment>> getComments(String itemId) async {
    return await _itemRepository.getComments(itemId);
  }

  Future<List<UserModel>> getUsers(List<String> userIds) async {
    return await _itemRepository.getUsers(userIds);
  }
}
