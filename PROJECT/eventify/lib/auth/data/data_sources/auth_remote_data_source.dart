import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/auth/domain/entities/user.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/user_model.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'AuthRemoteDataSource';

  Future<String?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user?.uid;
    } on firebase_auth.FirebaseAuthException catch (e) {
      log(AppLogs.firebaseAuthRegisterError, name: _tag, error: e);
      return null;
    } catch (e) {
      log(AppLogs.unexpectedRegisterError, name: _tag, error: e);
      return null;
    }
  }

  Future<void> saveUser(UserModel userModel) async {
    try {
      await _firestore
          .collection(AppFirestoreFields.users)
          .doc(userModel.id)
          .set(userModel.toJson());
    } catch (e) {
      log(AppLogs.firestoreSaveUserError, name: _tag, error: e);
      rethrow;
    }
  }

  Future<firebase_auth.UserCredential?> login(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      log(AppLogs.firebaseAuthLoginError, name: _tag, error: e);
      rethrow;
    } catch (e) {
      log(AppLogs.unexpectedLoginError, name: _tag, error: e);
      rethrow;
    }
  }

  Future<User?> signInWithGoogle(firebase_auth.User firebaseUser) async {
    try {
      final userDoc = _firestore
          .collection(AppFirestoreFields.users)
          .doc(firebaseUser.uid);
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        final newUser = UserModel(
          id: firebaseUser.uid,
          username: firebaseUser.displayName ?? 'Google User',
          email: firebaseUser.email ?? '',
        );
        await userDoc.set(newUser.toJson());
        return newUser.toDomain();
      } else {
        final userModel = UserModel.fromJson(snapshot.data()!, snapshot.id);
        return userModel.toDomain();
      }
    } catch (e) {
      log(AppLogs.errorSavingGoogleUserInfo, name: _tag, error: e);
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      log(AppLogs.firebaseAuthResetPasswordError, name: _tag, error: e);
      rethrow;
    } catch (e) {
      log(AppLogs.unexpectedResetPasswordError, name: _tag, error: e);
      rethrow;
    }
  }
}
