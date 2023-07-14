import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/utils/type_defs.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';
import 'package:gurme/models/user_model.dart';

final profileRepositoryProvider = Provider((ref) {
  return ProfileRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(authProvider),
    storage: ref.watch(storageProvider),
  );
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  ProfileRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _auth = auth,
        _storage = storage;

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

  FutureEither<bool> uploadProfilePicture(
      UserModel user, File newProfilePicture) async {
    String oldProfilePictureUrl = user.profilePic;
    String userId = user.uid;

    // if the user's profile picture isn't the default profile picture
    // delete the existing profile picture from database
    if (oldProfilePictureUrl != AssetConstants.defaultProfilePic) {
      final userProfilePic = 'user/${userId}_profilePicture';
      try {
        await _storage.ref().child(userProfilePic).delete();
      } catch (e) {
        return left('Fotoğraf değiştirilirken bir hata oluştu');
      }
    }

    String newProfilePictureFileName = '${userId}_profilePicture';

    final profilePictureRef =
        _storage.ref().child('user/$newProfilePictureFileName');

    final uploadTask = await profilePictureRef.putFile(newProfilePicture);

    if (uploadTask.state == TaskState.success) {
      final newUrl = await uploadTask.ref.getDownloadURL();
      await updateProfilePictureOfUser(user, newUrl);
      return right(true);
    } else if (uploadTask.state == TaskState.error) {
      return left('Fotoğraf değiştirilirken bir hata oluştu');
    }
    return left('Fotoğraf değiştirilirken bir hata oluştu');
  }

  FutureEither<void> updateProfilePictureOfUser(
      UserModel user, String pictureUrl) async {
    UserModel updatedUser = user.copyWith(profilePic: pictureUrl);

    try {
      return right(_users.doc(user.uid).update(updatedUser.toMap()));
    } catch (e) {
      return left('Fotoğraf değiştirilirken bir hata oluştu');
    }
  }

  FutureEither<bool> uploadBannerPicture(
      UserModel user, File newBannerPicture) async {
    String oldBannerPictureUrl = user.bannerPic;
    String userId = user.uid;

    // if the user's banner picture isn't the default banner picture
    // delete the existing banner picture from database
    if (oldBannerPictureUrl != AssetConstants.defaultBannerPic) {
      final userBannerPic = 'user/${userId}_bannerPicture';
      try {
        await _storage.ref().child(userBannerPic).delete();
      } catch (e) {
        return left('Fotoğraf değiştirilirken bir hata oluştu');
      }
    }

    String newBannerPictureFileName = '${userId}_bannerPicture';

    final bannerPictureRef =
        _storage.ref().child('user/$newBannerPictureFileName');

    final uploadTask = await bannerPictureRef.putFile(newBannerPicture);

    if (uploadTask.state == TaskState.success) {
      final newUrl = await uploadTask.ref.getDownloadURL();
      await updateBannerPictureOfUser(user, newUrl);
      return right(true);
    } else if (uploadTask.state == TaskState.error) {
      return left('Fotoğraf değiştirilirken bir hata oluştu');
    }
    return left('Fotoğraf değiştirilirken bir hata oluştu');
  }

  FutureEither<void> updateBannerPictureOfUser(
      UserModel user, String pictureUrl) async {
    UserModel updatedUser = user.copyWith(bannerPic: pictureUrl);

    try {
      return right(_users.doc(user.uid).update(updatedUser.toMap()));
    } catch (e) {
      return left('Fotoğraf değiştirilirken bir hata oluştu');
    }
  }

  FutureEither<void> updateUserName(UserModel user, String newName) async {
    final updatedUser = user.copyWith(name: newName);
    try {
      return right(_users.doc(user.uid).update(updatedUser.toMap()));
    } catch (e) {
      return left('İsim değişikliği sırasında bir hata oluşu');
    }
  }

  bool isUserSignedInWithMail() {
    if (_auth.currentUser == null) {
      return false;
    }

    // user signed in with google
    if (_auth.currentUser!.providerData[0].providerId
        .toLowerCase()
        .contains('google')) {
      return false;
    }

    return true;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser!.email;
  }
}
