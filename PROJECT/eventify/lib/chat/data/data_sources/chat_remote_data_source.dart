import 'dart:convert';
import 'dart:developer';

import 'package:eventify/common/constants/api_constants.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_logs.dart';
import 'package:http/http.dart' as http;

class ChatRemoteDataSource {
  final String _apiUrl = AppInternalConstants.chatApiUrl;

  static const int successStatusCode = 200;
  static const int candidateIndex = 0;
  static const int partIndex = 0;

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

      if (response.statusCode == successStatusCode) {
        final Map<String, dynamic> result = json.decode(response.body);
        if (result[AppInternalConstants.chatApiCandidatesKey] != null &&
            result[AppInternalConstants.chatApiCandidatesKey].isNotEmpty &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][candidateIndex][AppInternalConstants
                    .chatApiContentKey] !=
                null &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][candidateIndex][AppInternalConstants
                    .chatApiContentKey][AppInternalConstants.chatApiPartsKey] !=
                null &&
            result[AppInternalConstants
                    .chatApiCandidatesKey][candidateIndex][AppInternalConstants
                    .chatApiContentKey][AppInternalConstants.chatApiPartsKey]
                .isNotEmpty) {
          return result[AppInternalConstants
              .chatApiCandidatesKey][candidateIndex][AppInternalConstants
              .chatApiContentKey][AppInternalConstants
              .chatApiPartsKey][partIndex][AppInternalConstants.chatApiTextKey];
        } else {
          return AppInternalConstants.chatNoAIResponse;
        }
      } else {
        // Manejo de errores basado en el código de estado HTTP
        log(
          '${AppLogs.chatGeminiApiError} ${AppLogs.statusCode} ${response.statusCode}',
        );
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
