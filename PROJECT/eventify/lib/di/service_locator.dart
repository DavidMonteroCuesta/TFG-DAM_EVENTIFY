import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:eventify/chat/data/repositories/chat_repository_impl.dart';
import 'package:eventify/chat/domain/repositories/chat_repository.dart';
import 'package:eventify/chat/domain/use_cases/send_message_use_case.dart';
import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_nearest_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_year_use_case.dart';

final sl = GetIt.instance;

void setupLocator() {
  
// Auth feature
  sl.registerFactory(() => SignInViewModel(loginUseCase: sl()));
  sl.registerFactory(() => SignUpViewModel(
        registerUseCase: sl(),
        googleSignInUseCase: sl(),
      ));

  // Event feature
  sl.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSource());
  sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<GetEventsForUserUseCase>(
      () => GetEventsForUserUseCase(sl()));
  sl.registerLazySingleton<GetNearestEventUseCase>(
      () => GetNearestEventUseCase(sl()));
  sl.registerLazySingleton<GetEventsForUserAndMonthUseCase>(
      () => GetEventsForUserAndMonthUseCase(sl()));
  sl.registerLazySingleton<GetEventsForUserAndYearUseCase>(
      () => GetEventsForUserAndYearUseCase(sl()));
  sl.registerFactory<EventViewModel>(() => EventViewModel());

  // Chat feature
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSource());
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(sl()));
  sl.registerFactory<ChatViewModel>(() => ChatViewModel(sendMessageUseCase: sl()));
}

Future<void> init() async {
  setupLocator();
}
