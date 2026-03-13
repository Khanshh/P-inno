import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';
import '../services/ai_chat_service.dart';
import '../services/ai_chat_service.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _aiChatService = AiChatService();

  late AnimationController _backgroundController;

  // Premium Theme Colors (Modern Health-Tech)
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Hopeful gradient start
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF); // Matches Onboarding
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); // Soft blue-grey shadow

  final List<ChatMessage> _messages = [];
  bool _isThinking = false;
  bool _isTyping = false;
  Timer? _typingTimer;
  String? _errorMessage;
  String _sessionId = '';
  String _userId = '';
  List<ChatSession> _sessions = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('access_token') ?? 'user_demo';
    
    // Load existing sessions
    final sessions = await _aiChatService.getChatSessions(_userId);
    
    if (mounted) {
      setState(() {
        _sessions = sessions;
      });
      
      // Start a new session by default if none exists or as starting point
      _startNewChat();
    }
  }

  void _startNewChat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      _messages.clear();
      _messages.add(
        ChatMessage.assistant(
          'Xin chào${prefs.getString('user_full_name') != null ? ' ${prefs.getString('user_full_name')}' : ''}! Tôi là trợ lý AI y tế. Hôm nay tôi có thể giúp gì cho tình trạng sức khỏe của bạn?',
        ),
      );
    });
  }

  Future<void> _loadSession(String sessionId) async {
    setState(() {
      _isThinking = true;
      _sessionId = sessionId;
      _messages.clear();
    });
    
    try {
      final history = await _aiChatService.getChatHistory(sessionId);
      if (mounted) {
        setState(() {
          _messages.addAll(history);
          _isThinking = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _isThinking = false;
      });
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

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
      final minDelay = Future.delayed(const Duration(milliseconds: 1500));
      final apiCall = _aiChatService.sendMessage(
        messages: _messages,
        sessionId: _sessionId,
        userId: _userId,
      );
      
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
            content: Text(_errorMessage!, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        // After finishing, refresh sessions to update titles/previews
        _aiChatService.getChatSessions(_userId).then((sessions) {
          if (mounted) {
            setState(() {
              _sessions = sessions;
            });
          }
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 90, 
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
      key: _scaffoldKey,
      backgroundColor: _bgColor,
      endDrawer: _buildHistoryDrawer(),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
            children: [
              _buildGlassHeader(),
              Expanded(
                child: _buildChatBody(),
              ),
              _buildInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDrawer() {
    return Drawer(
      backgroundColor: _bgColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Lịch sử Chat',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Add "New Chat" Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _startNewChat();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add_rounded),
                label: Text('Cuộc hội thoại mới', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _sessions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'Chưa có lịch sử',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.blueGrey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      final session = _sessions[index];
                      final bool isCurrent = session.sessionId == _sessionId;
                      
                      return GestureDetector(
                        onTap: () {
                          _loadSession(session.sessionId);
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isCurrent ? _accentColor.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCurrent ? _accentColor : _darkShadow.withOpacity(0.3),
                              width: isCurrent ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _darkShadow.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.chat_rounded,
                                    size: 16,
                                    color: isCurrent ? _accentColor : Colors.blueGrey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      session.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: isCurrent ? _primaryColor : Colors.blueGrey.shade800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                session.lastMessage,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.blueGrey.shade500,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    session.timestamp.split('T').first,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 50 + (30 * _backgroundController.value),
              right: -100 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFE2F1AF).withOpacity(0.3)),
            ),
            Positioned(
              bottom: -150 + (40 * _backgroundController.value),
              left: -120 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD1F1F1).withOpacity(0.5)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)], // Hopeful gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trợ lý AI',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F1AF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Đang hoạt động',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white, size: 28),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: _messages.length + (_isThinking ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        final time = _formatTime(DateTime.now()); 

        if (message.isUser) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _buildUserChatBubble(
              message: message.content,
              time: time,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _darkShadow, blurRadius: 6, offset: const Offset(2, 2)),
                BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-2, -2)),
              ],
            ),
            child: Icon(Icons.smart_toy_rounded, color: _accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(24).copyWith(bottomLeft: const Radius.circular(8)),
              boxShadow: [
                BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 8, offset: const Offset(4, 4)),
                BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
              ],
            ),
            child: const _TypingDots(), 
          ),
        ],
      ),
    );
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28).copyWith(bottomRight: const Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(color: _primaryColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(3, 3)),
                  ],
                ),
                child: Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: _darkShadow, blurRadius: 6, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-2, -2)),
                ],
              ),
              child: Icon(Icons.smart_toy_rounded, color: _accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(28).copyWith(bottomLeft: const Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 8, offset: const Offset(4, 4)),
                    BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
                  ],
                ),
                child: Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(
            time,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 2)),
                    BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4)),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                onPressed: _isThinking || _isTyping ? null : _sendMessage,
              ),
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
        const SizedBox(width: 6),
        _buildDot(1),
        const SizedBox(width: 6),
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
        final double scale = (t < 0.5) ? 1.2 : 0.8;
        
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF4A9EAD),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
