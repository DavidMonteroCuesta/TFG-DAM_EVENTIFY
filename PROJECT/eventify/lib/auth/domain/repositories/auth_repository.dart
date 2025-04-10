abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password);
  // En una aplicación real, podrías tener más detalles en el registro.
}