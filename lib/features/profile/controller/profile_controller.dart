import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/string_constants.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/profile/repository/profile_repository.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  return ProfileController(
    ref: ref,
    profileRepository: ref.watch(profileRepositoryProvider),
  );
});

final getUserByIdProvider =
    FutureProvider.autoDispose.family((ref, String userId) {
  return ref.watch(profileControllerProvider.notifier).getUserById(userId);
});

final getFavoriteCompaniesProvider =
    FutureProvider.autoDispose.family((ref, List<String> favoriteCompanyIds) {
  return ref
      .watch(profileControllerProvider.notifier)
      .getFavoriteCompanies(favoriteCompanyIds);
});

class CommentData {
  final List<Comment> comments;
  final List<Item> items;

  CommentData({required this.items, required this.comments});
}

final getCommentsOfUserProvider = FutureProvider.family
    .autoDispose<CommentData, String>((ref, String userId) async {
  final comments = await ref
      .watch(profileControllerProvider.notifier)
      .getCommentsOfUser(userId);

  List<String> itemIds = [];
  for (var comment in comments) {
    itemIds.add(comment.itemId);
  }
  final items = await ref
      .watch(profileControllerProvider.notifier)
      .getItemsByIds(itemIds);
  return CommentData(items: items, comments: comments);
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _profileRepository;
  final Ref _ref;
  ProfileController({
    required ProfileRepository profileRepository,
    required Ref ref,
  })  : _ref = ref,
        _profileRepository = profileRepository,
        super(false);

  Future<UserModel> getUserById(String userId) async {
    return await _profileRepository.getUserById(userId);
  }

  Future<List<Comment>> getCommentsOfUser(String userId) async {
    return await _profileRepository.getCommentsOfUser(userId);
  }

  Future<List<Company>> getFavoriteCompanies(
      List<String> favoriteCompanyIds) async {
    return await _profileRepository.getFavoriteCompanies(favoriteCompanyIds);
  }

  Future<List<Item>> getItemsByIds(List<String> itemIds) async {
    return await _profileRepository.getItemsByIds(itemIds);
  }

  Future<void> removeFromFavorites(UserModel user, String companyId) async {
    final response =
        await _profileRepository.removeFromFavorites(user, companyId);

    response.fold((error) => showToast(error), (r) {
      final List<String> updatedCompanyIds = user.favoriteCompanyIds;
      updatedCompanyIds.remove(companyId);

      _ref.read(userProvider.notifier).update(
          (state) => state!.copyWith(favoriteCompanyIds: updatedCompanyIds));
    });
  }

  Future<void> addToFavorites(UserModel user, String companyId) async {
    final response = await _profileRepository.addToFavorites(user, companyId);

    response.fold((error) => showToast(error), (r) {
      final List<String> updatedCompanyIds = user.favoriteCompanyIds;
      if (!updatedCompanyIds.contains(companyId)) {
        updatedCompanyIds.add(companyId);
      }

      _ref.read(userProvider.notifier).update(
          (state) => state!.copyWith(favoriteCompanyIds: updatedCompanyIds));
    });
  }

  Future<bool> uploadProfilePicture(
      UserModel user, File newProfilePicture) async {
    final response =
        await _profileRepository.uploadProfilePicture(user, newProfilePicture);

    response.fold((error) {
      showToast(error);
      return false;
    }, (newUrl) {
      _ref
          .read(userProvider.notifier)
          .update((state) => state!.copyWith(profilePic: newUrl));
      showToast(SuccessMessageConstants.profilePictureSuccessfullyUpdated);
      return true;
    });

    return false;
  }

  Future<bool> uploadBannerPicture(
      UserModel user, File newBannerPicture) async {
    final response =
        await _profileRepository.uploadBannerPicture(user, newBannerPicture);

    response.fold((error) {
      showToast(error);
      return false;
    }, (newUrl) {
      _ref
          .read(userProvider.notifier)
          .update((state) => state!.copyWith(bannerPic: newUrl));
      showToast(SuccessMessageConstants.bannerPictureSuccessfullyUpdated);
      return true;
    });

    return false;
  }

  Future<void> updateUserName(UserModel user, String newName) async {
    final response = await _profileRepository.updateUserName(user, newName);

    response.fold(
      (error) => showToast(error),
      (r) => _ref.read(userProvider.notifier).update(
            (state) => state!.copyWith(name: newName),
          ),
    );
  }

  bool isUserSignedInWithMail() {
    return _profileRepository.isUserSignedInWithMail();
  }

  String? getCurrentUserEmail() {
    return _profileRepository.getCurrentUserEmail();
  }
}
