import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventify/common/constants/api_constants.dart'; // Asegúrate de tener este archivo con tu API_KEY

class ChatRemoteDataSource {
  // Define la URL base de la API de Gemini
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> sendMessage(String message) async {
    try {
      // Historial de chat para la solicitud de Gemini
      List<Map<String, dynamic>> chatHistory = [
        {"role": "user", "parts": [{"text": message}]}
      ];

      // Payload para la solicitud de la API de Gemini
      final Map<String, dynamic> payload = {
        "contents": chatHistory,
      };

      // Realiza la solicitud POST a la API de Gemini
      final response = await http.post(
        Uri.parse('$_apiUrl?key=${ApiConstants.apiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        // Extrae el texto de la respuesta del bot
        if (result['candidates'] != null &&
            result['candidates'].isNotEmpty &&
            result['candidates'][0]['content'] != null &&
            result['candidates'][0]['content']['parts'] != null &&
            result['candidates'][0]['content']['parts'].isNotEmpty) {
          return result['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return 'No se pudo obtener una respuesta de la IA.';
        }
      } else {
        // Manejo de errores basado en el código de estado HTTP
        print('Error en la API de Gemini: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return 'Error al conectar con la IA: ${response.statusCode}';
      }
    } catch (e) {
      // Manejo de errores de red o cualquier otra excepción
      print('Excepción al enviar mensaje a la IA: $e');
      return 'Ocurrió un error inesperado al enviar el mensaje.';
    }
  }
}
