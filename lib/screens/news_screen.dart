import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../widgets/ai_summary_dialog.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late AnimationController _backgroundController;

  List<NewsModel> _news = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadNews();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.getNews(page: 1, limit: 20);
      if (mounted) {
        setState(() {
          _news = response.items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Không thể tải tin tức. Vui lòng thử lại sau.';
          _isLoading = false;
        });
      }
    }
  }

  String _formatViews(int views) {
    if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1).replaceAll('.0', '')}k';
    }
    return views.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
            children: [
              _buildGlassHeader(),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: _accentColor))
                    : _errorMessage != null
                        ? _buildErrorPlaceholder()
                        : _news.isEmpty
                            ? _buildEmptyPlaceholder()
                            : RefreshIndicator(
                                onRefresh: _loadNews,
                                color: _accentColor,
                                backgroundColor: Colors.white,
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: _news.length,
                                  itemBuilder: (context, index) {
                                    return _NewsCard(
                                      news: _news[index],
                                      formatViews: _formatViews,
                                      accentColor: _accentColor,
                                      primaryColor: _primaryColor,
                                      darkShadow: _darkShadow,
                                    );
                                  },
                                ),
                              ),
              ),
            ],
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
              top: 150 + (30 * _backgroundController.value),
              right: -100 + (25 * _backgroundController.value),
              child: _buildOrb(420, const Color(0xFFD1F1D1).withOpacity(0.4)),
            ),
            Positioned(
              bottom: 150 + (40 * _backgroundController.value),
              left: -120 + (20 * _backgroundController.value),
              child: _buildOrb(480, const Color(0xFFD1E2F1).withOpacity(0.5)),
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
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
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
        bottom: 30,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Tin Tức Y Tế',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadNews,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Thử lại', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Hiện chưa có tin tức.',
            style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel news;
  final String Function(int) formatViews;
  final Color accentColor;
  final Color primaryColor;
  final Color darkShadow;

  const _NewsCard({
    required this.news,
    required this.formatViews,
    required this.accentColor,
    required this.primaryColor,
    required this.darkShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAISummaryDialog(context, news),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: darkShadow.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with glass label
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  news.imageUrl != null
                      ? Image.network(
                          news.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: accentColor.withOpacity(0.1),
                            child: Icon(Icons.image_not_supported_rounded, color: accentColor, size: 30),
                          ),
                        )
                      : Container(
                          color: accentColor.withOpacity(0.1),
                          child: Icon(Icons.image_not_supported_rounded, color: accentColor, size: 30),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            formatViews(news.views),
                            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content area
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.blueGrey.shade600,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 12, color: accentColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            news.time,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
