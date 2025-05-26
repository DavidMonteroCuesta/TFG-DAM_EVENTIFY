import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventify/common/constants/api_constants.dart';
import 'package:eventify/common/constants/app_internal_constants.dart'; // Import AppInternalConstants

class ChatRemoteDataSource {
  // Define la URL base de la API de Gemini
  final String _apiUrl = AppInternalConstants.chatApiUrl;

  Future<String> sendMessage(String message) async {
    try {
      // Historial de chat para la solicitud de Gemini
      List<Map<String, dynamic>> chatHistory = [
        {
          // CORRECTED LINE: The key must be "role", and its value is the constant for "user"
          "role": AppInternalConstants.chatApiRoleUser,
          AppInternalConstants.chatApiPartsKey: [
            {AppInternalConstants.chatApiTextKey: message}
          ]
        }
      ];

      // Payload para la solicitud de la API de Gemini
      final Map<String, dynamic> payload = {
        AppInternalConstants.chatApiContentsKey: chatHistory,
      };

      // Realiza la solicitud POST a la API de Gemini
      final response = await http.post(
        Uri.parse('$_apiUrl?key=${ApiConstants.geminiApiKey}'),
        headers: {'Content-Type': AppInternalConstants.chatApiContentTypeHeader},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        // Extrae el texto de la respuesta del bot
        if (result[AppInternalConstants.chatApiCandidatesKey] != null &&
            result[AppInternalConstants.chatApiCandidatesKey].isNotEmpty &&
            result[AppInternalConstants.chatApiCandidatesKey][0][AppInternalConstants.chatApiContentKey] != null &&
            result[AppInternalConstants.chatApiCandidatesKey][0][AppInternalConstants.chatApiContentKey][AppInternalConstants.chatApiPartsKey] != null &&
            result[AppInternalConstants.chatApiCandidatesKey][0][AppInternalConstants.chatApiContentKey][AppInternalConstants.chatApiPartsKey].isNotEmpty) {
          return result[AppInternalConstants.chatApiCandidatesKey][0][AppInternalConstants.chatApiContentKey][AppInternalConstants.chatApiPartsKey][0][AppInternalConstants.chatApiTextKey];
        } else {
          return AppInternalConstants.chatNoAIResponse;
        }
      } else {
        // Manejo de errores basado en el código de estado HTTP
        print('${AppInternalConstants.chatGeminiApiError}${response.statusCode}');
        print('${AppInternalConstants.chatResponseBody}${response.body}');
        return '${AppInternalConstants.chatConnectionError}${response.statusCode}';
      }
    } catch (e) {
      // Manejo de errores de red o cualquier otra excepción
      print('${AppInternalConstants.chatExceptionSendingMessage}$e');
      return AppInternalConstants.chatUnexpectedError;
    }
  }
}