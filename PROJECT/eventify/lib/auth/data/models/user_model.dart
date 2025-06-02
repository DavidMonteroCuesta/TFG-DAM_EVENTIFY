import 'package:eventify/auth/domain/entities/user.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({required this.id, required this.username, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      username: json[AppFirestoreFields.username] as String,
      email: json[AppFirestoreFields.email] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppFirestoreFields.username: username,
      AppFirestoreFields.email: email,
    };
  }

  User toDomain() {
    return User(id: id, username: username, email: email);
  }
}
