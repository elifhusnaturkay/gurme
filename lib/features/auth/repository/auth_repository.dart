import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/firebase_constants.dart';
import 'package:gurme/core/providers/firebase_providers.dart';
import 'package:gurme/common/utils/type_defs.dart';
import 'package:gurme/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

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
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic:
              userCredential.user!.photoURL ?? AssetConstants.defaultProfilePic,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          comments: [],
        );
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEither<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } on FirebaseException catch (e) {
      return left(e.toString());
    } catch (e) {
      return left(e.toString());
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
          comments: [],
        );
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _auth.currentUser!.sendEmailVerification();

      UserModel userModel = UserModel(
        name: userCredential.user!.displayName ?? name,
        profilePic:
            userCredential.user!.photoURL ?? AssetConstants.defaultProfilePic,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        comments: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }
}
