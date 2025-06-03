import 'package:eventify/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:eventify/auth/data/repositories/auth_repository_impl.dart';
import 'package:eventify/auth/domain/repositories/auth_repository.dart';
import 'package:eventify/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:eventify/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_year_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_nearest_event_use_case.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:eventify/chat/data/repositories/chat_repository_impl.dart';
import 'package:eventify/chat/domain/repositories/chat_repository.dart';
import 'package:eventify/chat/domain/use_cases/send_message_use_case.dart';
import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // Instancia de GetIt para inyección de dependencias

void setupLocator() {
  // --- Auth feature ---
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => RegisterUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => GoogleSignInUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton(
    () => SendPasswordResetEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory(
    () => SignInViewModel(
      loginUseCase: sl(),
      sendPasswordResetEmailUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => SignUpViewModel(registerUseCase: sl(), googleSignInUseCase: sl()),
  );

  // --- Event feature ---
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSource(),
  );
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetEventsForUserUseCase>(
    () => GetEventsForUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetNearestEventUseCase>(
    () => GetNearestEventUseCase(sl()),
  );
  sl.registerLazySingleton<GetEventsForUserAndMonthUseCase>(
    () => GetEventsForUserAndMonthUseCase(sl()),
  );
  sl.registerLazySingleton<GetEventsForUserAndYearUseCase>(
    () => GetEventsForUserAndYearUseCase(sl()),
  );
  sl.registerFactory<EventViewModel>(() => EventViewModel());

  // --- Chat feature ---
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSource());
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl()));
  sl.registerFactory<ChatViewModel>(
    () => ChatViewModel(sendMessageUseCase: sl()),
  );
}

Future<void> init() async {
  setupLocator(); // Inicializa todos los servicios y dependencias
}
