import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/string_constants.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
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
    String userId = ref.watch(userProvider.notifier).state!.uid;
    return ref
        .watch(itemControllerProvider.notifier)
        .getComments(itemId, userId);
  },
);

class ItemController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;

  ItemController({required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(false);

  Stream<List<Comment>> getComments(String itemId, String userId) {
    return _itemRepository.getComments(itemId, userId);
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

  Future<void> deleteComment(
      String commentId, Comment oldComment, Item item) async {
    final response =
        await _itemRepository.deleteComment(commentId, oldComment, item);

    response.fold((error) => showToast(error),
        (r) => showToast(SuccessMessageConstants.successfullyDeleted));
  }
}
