import 'package:eventify/auth/domain/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/domain/presentation/view_model/sign_up_view_model.dart';
import 'package:get_it/get_it.dart';
import '../auth/data/data_sources/auth_remote_data_source.dart';
import '../auth/data/repositories/auth_repository_impl.dart';
import '../auth/domain/repositories/auth_repository.dart';
import '../auth/domain/use_cases/login_use_case.dart';
import '../auth/domain/use_cases/register_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth Feature
  sl.registerFactory(() => SignInViewModel(loginUseCase: sl()));
  sl.registerFactory(() => SignUpViewModel(registerUseCase: sl()));
  sl.registerLazySingleton(() =>LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => AuthRemoteDataSource());
}