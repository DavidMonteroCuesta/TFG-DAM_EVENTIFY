import 'package:eventify/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<String> execute(String message) {
    return repository.sendMessage(message);
  }
}