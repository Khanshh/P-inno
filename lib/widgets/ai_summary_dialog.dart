import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../screens/news_detail_screen.dart';

void showAISummaryDialog(BuildContext context, NewsModel item) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'AI Summary',
    barrierColor: Colors.black.withOpacity(0.35), // Giảm độ tối hình nền để app trông sáng sủa hơn
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: _AISummaryDialogContent(item: item),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

class _AISummaryDialogContent extends StatefulWidget {
  final NewsModel item;

  const _AISummaryDialogContent({required this.item});

  @override
  State<_AISummaryDialogContent> createState() => _AISummaryDialogContentState();
}

class _AISummaryDialogContentState extends State<_AISummaryDialogContent> with SingleTickerProviderStateMixin {
  late NewsModel _currentItem;
  bool _isLoading = false;
  String? _error;

  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF);

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    if (_currentItem.summary == null || _currentItem.content == null) {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await ApiService().getNewsDetail(_currentItem.id);
      if (mounted) {
        setState(() {
          _currentItem = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Không thể tải tóm tắt. Vui lòng thử lại.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxHeight: 650),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5), // Viền sáng giúp dialog nổi bật
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow Orbs - Tăng sáng orbs
          Positioned(
            top: -50,
            right: -50,
            child: _buildOrb(200, _accentColor.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildOrb(220, const Color(0xFFE2F1AF).withOpacity(0.2)),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Brighter Gradient
              Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8EDFEF), Color(0xFF73C6D9)], // Gradient sáng hơn, tươi tắn hơn
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4), // Tăng độ trắng cho icon box
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI Tóm tắt tin tức",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isLoading ? "Đang phân tích dữ liệu..." : "Bản tóm tắt độc quyền của bạn",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title Box (Glassy)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Text(
                        _currentItem.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Content Body
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _accentColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Nội dung trọng tâm",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: _primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (_isLoading)
                        _buildLoadingState()
                      else if (_error != null)
                        _buildErrorState()
                      else
                        Text(
                          _currentItem.summary ?? "Chưa có bản tóm tắt cho bài viết này.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.blueGrey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 24),
                      _buildAITag(),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              _buildActionRow(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "AI đang xử lý nội dung...",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red.shade300, size: 40),
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.red.shade400, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _fetchDetail,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Thử lại ngay"),
            style: TextButton.styleFrom(foregroundColor: _accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAITag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 14, color: _accentColor.withOpacity(0.6)),
          const SizedBox(width: 8),
          Text(
            "Phân tích bởi AI Gemini - Độ tin cậy cao",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                "Đóng",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.blueGrey.shade400,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.35),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(news: _currentItem),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Đọc chi tiết",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
