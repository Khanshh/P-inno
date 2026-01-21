import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/chat_message_model.dart';

class AiChatService {
  static final AiChatService _instance = AiChatService._internal();
  factory AiChatService() => _instance;
  AiChatService._internal();

  /// Send a message to the AI chat endpoint
  /// 
  /// [messages] - Full conversation history
  /// [sessionId] - Optional session ID for persistent conversations
  /// [useRag] - Whether to use RAG (Retrieval Augmented Generation) for context-aware responses
  Future<ChatResponse> sendMessage({
    required List<ChatMessage> messages,
    String? sessionId,
    bool useRag = false,
  }) async {
    try {
      final request = ChatRequest(
        messages: messages,
        sessionId: sessionId,
        useRag: useRag,
      );

      final response = await http.post(
        Uri.parse(ApiConfig.aiChat),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChatResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to get AI response: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }

  /// Send a simple text message (convenience method)
  /// 
  /// This creates a single user message and sends it to the AI
  Future<ChatResponse> sendSimpleMessage(String message) async {
    return sendMessage(
      messages: [ChatMessage.user(message)],
    );
  }
}
