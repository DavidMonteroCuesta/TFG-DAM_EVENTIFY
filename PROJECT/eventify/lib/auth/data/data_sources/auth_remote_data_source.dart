import 'package:eventify/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'dart:developer';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'AuthRemoteDataSource';

  Future<String?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Firebase Auth Register Error: ${e.message}',
          name: _tag, error: e);
      return null;
    } catch (e) {
      log('Unexpected Register Error: $e', name: _tag, error: e);
      return null;
    }
  }

  Future<void> saveUser(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson());
    } catch (e) {
      log('Firestore Save User Error: $e', name: _tag, error: e);
      rethrow;
    }
  }

  // Modifica la función login para que devuelva Future<UserCredential?>
  Future<firebase_auth.UserCredential?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Firebase Auth Login Error: ${e.message}', name: _tag, error: e);
      rethrow;
    } catch (e) {
      log('Unexpected Login Error: $e', name: _tag, error: e);
      rethrow;
    }
  }

  Future<User?> signInWithGoogle(firebase_auth.User firebaseUser) async {
    try {
      final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
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
      log('Error saving Google user info to Firestore: $e',
          name: _tag, error: e);
      return null;
    }
  }
}