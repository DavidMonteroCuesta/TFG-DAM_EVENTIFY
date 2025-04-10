import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<bool> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}