import 'package:eventify/auth/domain/repositories/auth_repository.dart';

// Caso de uso para enviar un correo de restablecimiento de contraseña
class SendPasswordResetEmailUseCase {
  final AuthRepository repository;
  SendPasswordResetEmailUseCase(this.repository);

  Future<void> execute(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}
