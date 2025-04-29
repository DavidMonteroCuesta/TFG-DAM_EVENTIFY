import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'dart:developer'; // Import the log function

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'AuthRemoteDataSource'; // Optional: Add a tag for easier filtering

  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Register Error: ${e.message}', name: _tag, error: e);
      return null;
    } catch (e) {
      log('Unexpected Register Error: $e', name: _tag, error: e);
      return null;
    }
  }

  Future<void> saveUser(UserModel userModel) async {
  try {
    await _firestore.collection('users').doc(userModel.id).set(userModel.toJson());
  } catch (e) {
    log('Firestore Save User Error: $e', name: _tag, error: e);
    rethrow;
  }
}

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Login Error: ${e.message}', name: _tag, error: e);
      return false;
    } catch (e) {
      log('Unexpected Login Error: $e', name: _tag, error: e);
      return false;
    }
  }
}