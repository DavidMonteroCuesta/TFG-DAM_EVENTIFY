import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User?> register(String email, String password, String username) async {
    final String? userId = await remoteDataSource.registerWithEmailAndPassword(email, password);
    if (userId != null) {
      final UserModel userModel = UserModel(id: userId, username: username, email: email);
      await remoteDataSource.saveUser(userModel);
      return userModel.toDomain();
    }
    return null;
  }
}