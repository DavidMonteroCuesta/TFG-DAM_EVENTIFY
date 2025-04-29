import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<User?> register(String email, String password, String username);
}