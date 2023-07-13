import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/item/repository/item_repository.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

final itemControllerProvider =
    StateNotifierProvider<ItemController, bool>((ref) {
  return ItemController(itemRepository: ref.watch(itemRepositoryProvider));
});

final getCommentsProvider = StreamProvider.family.autoDispose(
  (ref, String itemId) {
    return ref.watch(itemControllerProvider.notifier).getComments(itemId);
  },
);

class ItemController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;

  ItemController({required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(false);

  Stream<List<Comment>> getComments(String itemId) {
    return _itemRepository.getComments(itemId);
  }

  Future<void> sendComment(
      UserModel user, Item item, int rating, String text) async {
    final response =
        await _itemRepository.sendComment(user, item, rating, text);

    response.fold((error) => showToast(error), (r) => {});
  }

  Future<void> updateComment(Comment comment, UserModel user, Item item,
      int rating, String text) async {
    final response =
        await _itemRepository.updateComment(comment, item, rating, text);

    response.fold((error) => showToast(error), (r) => {});
  }
}
