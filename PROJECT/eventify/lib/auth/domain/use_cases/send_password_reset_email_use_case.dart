import 'package:eventify/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;
  SendPasswordResetEmailUseCase(this.repository);

  Future<void> execute(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}
