class AuthRemoteDataSource {
  Future<bool> login(String email, String password) async {
    // Simulación de lógica de autenticación
    await Future.delayed(const Duration(seconds: 1));
    return email == 'test@example.com' && password == 'password';
    // En una aplicación real, harías una llamada a una API aquí.
  }

  Future<bool> register(String email, String password) async {
    // Simulación de lógica de registro
    await Future.delayed(const Duration(seconds: 1));
    return true; // Simula un registro exitoso
    // En una aplicación real, harías una llamada a una API de registro aquí.
  }
}