import 'package:eventify/auth/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Caso de uso para registrar un nuevo usuario
class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<User?> execute(String email, String password, String username) async {
    return await authRepository.register(email, password, username);
  }
}
