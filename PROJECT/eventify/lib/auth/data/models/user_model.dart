import 'package:eventify/auth/domain/entities/user.dart';

class UserModel {
  final String? id;
  final String email;

  UserModel({this.id, required this.email});

  // Métodos para convertir de/a JSON si estás usando una API
  // UserModel.fromJson(Map<String, dynamic> json) : ...
  // Map<String, dynamic> toJson() : ...

  // Método para convertir a la entidad de dominio
  User toDomain() {
    return User(id: id ?? '', username: email.split('@')[0], email: email);
  }

  // Método para crear un UserModel desde una entidad de dominio (si es necesario)
  factory UserModel.fromDomain(User user) {
    return UserModel(id: user.id, email: user.email);
  }
}