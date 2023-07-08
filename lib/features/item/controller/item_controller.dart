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

final getCommentsProvider = FutureProvider.family.autoDispose(
  (ref, String itemId) {
    return ref.watch(itemControllerProvider.notifier).getComments(itemId);
  },
);

class ItemController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;

  ItemController({required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(false);

  Future<List<Comment>> getComments(String itemId) async {
    return await _itemRepository.getComments(itemId);
  }
}
