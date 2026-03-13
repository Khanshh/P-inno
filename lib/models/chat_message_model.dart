class ChatMessage {
  final String role;
  final String content;

  ChatMessage({
    required this.role,
    required this.content,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  // Helper constructors
  factory ChatMessage.user(String content) {
    return ChatMessage(role: 'user', content: content);
  }

  factory ChatMessage.assistant(String content) {
    return ChatMessage(role: 'assistant', content: content);
  }

  factory ChatMessage.system(String content) {
    return ChatMessage(role: 'system', content: content);
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isSystem => role == 'system';
}

class ChatRequest {
  final List<ChatMessage> messages;
  final String? sessionId;
  final String? userId;
  final bool useRag;

  ChatRequest({
    required this.messages,
    this.sessionId,
    this.userId,
    this.useRag = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      'use_rag': useRag,
    };
  }
}

class ChatResponse {
  final ChatMessage reply;
  final String? sessionId;
  final List<String>? retrievedContext;

  ChatResponse({
    required this.reply,
    this.sessionId,
    this.retrievedContext,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reply: ChatMessage.fromJson(json['reply'] as Map<String, dynamic>),
      sessionId: json['session_id'] as String?,
      retrievedContext: (json['retrieved_context'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
class ChatSession {
  final String sessionId;
  final String title;
  final String lastMessage;
  final String timestamp;

  ChatSession({
    required this.sessionId,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['session_id'] as String,
      title: json['title'] as String,
      lastMessage: json['last_message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}
