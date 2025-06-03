import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:eventify/common/constants/api_constants.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_logs.dart';

class ChatRemoteDataSource {
  final String _apiUrl = AppInternalConstants.chatApiUrl;

  Future<String> sendMessage(String message) async {
    try {
      List<Map<String, dynamic>> chatHistory = [
        {
          "role": AppInternalConstants.chatApiRoleUser,
          AppInternalConstants.chatApiPartsKey: [
            {AppInternalConstants.chatApiTextKey: message},
          ],
        },
      ];

      final Map<String, dynamic> payload = {
        AppInternalConstants.chatApiContentsKey: chatHistory,
      };

      final response = await http.post(
        Uri.parse('$_apiUrl?key=${ApiConstants.geminiApiKey}'),
        headers: {
          'Content-Type': AppInternalConstants.chatApiContentTypeHeader,
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        if (result[AppInternalConstants.chatApiCandidatesKey] != null &&
            result[AppInternalConstants.chatApiCandidatesKey].isNotEmpty &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][0][AppInternalConstants
                    .chatApiContentKey] !=
                null &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][0][AppInternalConstants
                    .chatApiContentKey][AppInternalConstants.chatApiPartsKey] !=
                null &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][0][AppInternalConstants
                    .chatApiContentKey][AppInternalConstants.chatApiPartsKey]
                .isNotEmpty) {
          return result[AppInternalConstants
              .chatApiCandidatesKey][0][AppInternalConstants
              .chatApiContentKey][AppInternalConstants
              .chatApiPartsKey][0][AppInternalConstants.chatApiTextKey];
        } else {
          return AppInternalConstants.chatNoAIResponse;
        }
      } else {
        // Manejo de errores basado en el código de estado HTTP
        log('${AppLogs.chatGeminiApiError} ${AppLogs.statusCode} ${response.statusCode}',);
        log('${AppLogs.chatResponseBody} ${response.body}');
        return '${AppInternalConstants.chatConnectionError}${response.statusCode}';
      }
    } catch (e) {
      // Manejo de errores de red o cualquier otra excepción
      log('${AppLogs.chatExceptionSendingMessage} $e');
      return AppInternalConstants.chatUnexpectedError;
    }
  }
}
