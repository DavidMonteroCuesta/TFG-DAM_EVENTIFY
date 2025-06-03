import 'package:eventify/chat/domain/repositories/chat_repository.dart';

// Caso de uso para enviar un mensaje a través del repositorio de chat
class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  // Ejecuta el envío de mensaje y devuelve la respuesta de la IA
  Future<String> execute(String message) {
    return repository.sendMessage(message);
  }
}
