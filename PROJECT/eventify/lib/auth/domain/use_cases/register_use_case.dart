import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<bool> execute(String email, String password) async {
    return await repository.register(email, password);
  }
}