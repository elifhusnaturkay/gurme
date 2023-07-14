import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/firebase_constants.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/common/utils/type_defs.dart';
import 'package:gurme/models/user_model.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
    storage: ref.read(storageProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage _storage;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _storage = storage;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanged => _auth.authStateChanges();

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        String? profilePictureUrl;
        if (userCredential.user!.photoURL != null) {
          profilePictureUrl = await storeProfilePicture(
              userCredential.user!.photoURL!, userCredential.user!.uid);
        }
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: profilePictureUrl ?? AssetConstants.defaultProfilePic,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          bannerPic: AssetConstants.defaultBannerPic,
          favoriteCompanyIds: [],
        );

        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        return left('İnternet bağlantısında bir problem oluştu');
      } else if (e.code == 'sign_in_failed') {
        return left('Giriş yapılırken bir hata oldu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
  }

  Future<String> storeProfilePicture(String photoUrl, String userId) async {
    final userProfilePic = 'user/${userId}_profilePicture';

    try {
      final userProfileRef = _storage.ref().child(userProfilePic);

      final Response response = await get(Uri.parse(photoUrl));
      final Uint8List imageData = response.bodyBytes;

      final uploadTask = await userProfileRef.putData(imageData);

      if (uploadTask.state == TaskState.success) {
        String pictureUrl = await uploadTask.ref.getDownloadURL();
        return pictureUrl;
      } else if (uploadTask.state == TaskState.error) {
        print(uploadTask.state.name);
        throw Exception('Bilinmeyen bir hata oluştu');
      }
    } catch (e) {
      throw Exception('Bilinmeyen bir hata oluştu');
    }

    throw Exception('Bilinmeyen bir hata oluştu');
  }

  FutureEither<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
    return right(null);
  }

  FutureEither<UserModel> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (!(_auth.currentUser!.emailVerified)) {
        await _auth.currentUser!.sendEmailVerification();
      }

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic:
              userCredential.user!.photoURL ?? AssetConstants.defaultProfilePic,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          bannerPic: AssetConstants.defaultBannerPic,
          favoriteCompanyIds: [],
        );
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return left('Bu e-posta adresi ile bir kullanıcı bulunamadı');
      } else if (e.code == 'invalid-email') {
        return left('Lütfen geçerli bir email adresi giriniz');
      } else if (e.code == 'wrong-password') {
        return left('Şifre yanlış, lütfen tekrar deneyiniz');
      } else if (e.code == 'operation-not-allowed') {
        return left('Kullanıcı bulunamadı tekrar deneyiniz');
      } else if (e.code == 'user-disabled') {
        return left('Kullanıcı bulunamadı tekrar deneyiniz');
      } else if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
  }

  FutureEither<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _auth.currentUser!.sendEmailVerification();

      UserModel userModel = UserModel(
        name: name,
        profilePic:
            userCredential.user!.photoURL ?? AssetConstants.defaultProfilePic,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        bannerPic: AssetConstants.defaultBannerPic,
        favoriteCompanyIds: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(
            'Bu e-posta ile bir kullanıcı zaten kayıtlı.\nLütfen giriş yapınız ya da farklı bir e-posta deneyiniz');
      } else if (e.code == 'invalid-email') {
        return left('Lütfen geçerli bir email adresi giriniz');
      } else if (e.code == 'weak-password') {
        return left('Şifre çok zayıf tekrar deneyiniz');
      } else if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
  }

  FutureEither<UserModel> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      UserModel userModel = UserModel(
        name: 'Misafir',
        profilePic: AssetConstants.defaultProfilePic,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        bannerPic: AssetConstants.defaultBannerPic,
        favoriteCompanyIds: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
  }

  FutureEither<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        return left('Lütfen geçerli bir email adresi giriniz');
      } else if (e.code == 'user-not-found') {
        return left('Bu e-posta adresi ile bir kullanıcı bulunamadı');
      } else if (e.code == 'network-request-failed') {
        return left('İnternet bağlantısında bir problem oluştu');
      }
      return left('Bilinmeyen bir hata oluştu');
    } catch (e) {
      return left('Bilinmeyen bir hata oluştu');
    }
    return right(null);
  }
}
