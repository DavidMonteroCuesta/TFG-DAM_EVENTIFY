import 'package:eventify/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:eventify/chat/domain/repositories/chat_repository.dart';

// Implementación del repositorio de chat que delega en el data source remoto
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> sendMessage(String message) {
    return remoteDataSource.sendMessage(message);
  }
}
