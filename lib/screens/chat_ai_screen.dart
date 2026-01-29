import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message_model.dart';
import '../services/ai_chat_service.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final Color _primaryColor = const Color(0xFF73C6D9);
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _aiChatService = AiChatService();

  final List<ChatMessage> _messages = [];
  final bool _isLoading = false;
  String? _errorMessage;

  final List<String> _quickReplies = const [];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage.assistant(
        'Xin chào! Tôi là trợ lý AI sức khỏe. Tôi có thể giúp gì cho bạn hôm nay?',
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  bool _isThinking = false; // "..." state
  bool _isTyping = false;   // Streaming text state
  Timer? _typingTimer;

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    // Block if thinking or typing
    if (text.isEmpty || _isThinking || _isTyping) return;

    // Clear input immediately
    _textController.clear();

    // 1. Add User Msg & Show Thinking Bubble
    setState(() {
      _messages.add(ChatMessage.user(text));
      _isThinking = true; 
      _errorMessage = null;
    });

    // Scroll to bottom to show the "..." bubble
    _scrollToBottom();

    try {
      // 2. Thinking Delay (Simulate processing + Real API call)
      // Wait for at least 1.5 seconds AND the API response
      final minDelay = Future.delayed(const Duration(milliseconds: 1500));
      final apiCall = _aiChatService.sendMessage(messages: _messages);
      
      final results = await Future.wait([minDelay, apiCall]);
      final response = results[1] as ChatResponse;

      // 3. Hide Thinking & Start Stream
      setState(() {
        _isThinking = false;
      });
      
      _streamResponse(response.reply.content);

    } catch (e) {
      setState(() {
        _isThinking = false;
        _errorMessage = 'Không thể kết nối với AI. Vui lòng thử lại.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _streamResponse(String fullText) {
    if (!mounted) return;

    setState(() {
      _isTyping = true;
      // Add empty bot message to start streaming
      _messages.add(ChatMessage.assistant("")); 
    });
    
    _scrollToBottom();

    int index = 0;
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (index < fullText.length) {
        setState(() {
          final currentText = _messages.last.content;
          final newText = currentText + fullText[index];
          
          _messages.removeLast();
          _messages.add(ChatMessage.assistant(newText));
        });
        index++;
        _scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60, 
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildChatBody(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Color(0xFF73C6D9),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trợ lý AI sức khỏe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Đang hoạt động',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      // Add thinking bubble at the end if _isThinking is true
      itemCount: _messages.length + (_isThinking ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // This must be the thinking bubble
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        final time = _formatTime(DateTime.now()); 

        if (message.isUser) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildUserChatBubble(
              message: message.content,
              time: time,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildAIChatBubble(
              message: message.content,
              time: time,
            ),
          );
        }
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Color(0xFF73C6D9),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: _TypingDots(), // Custom widget for animated dots
          ),
        ],
      ),
    );
  }
  
  // Removed _buildLoadingIndicator as requested


  Widget _buildUserChatBubble({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomRight: const Radius.circular(4),
                  ),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAIChatBubble({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFF73C6D9),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: const Radius.circular(4),
                  ),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickReplies() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _quickReplies.map((reply) {
        return InkWell(
          onTap: () {
            // TODO: Handle quick reply tap
            _textController.text = reply;
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _primaryColor,
                width: 1.5,
              ),
            ),
            child: Text(
              reply,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black87),
              onPressed: () {
                // TODO: Show attachment options
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Aa',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 16),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined,
                          color: Colors.grey),
                      onPressed: () {
                        // TODO: Show emoji picker
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _isLoading ? Colors.grey : const Color(0xFF73C6D9),
              ),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        const SizedBox(width: 4),
        _buildDot(1),
        const SizedBox(width: 4),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = (_controller.value + index * 0.2) % 1.0;
        final double opacity = (t < 0.5) ? 1.0 : 0.3;
        
        return Opacity(
          opacity: opacity,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

