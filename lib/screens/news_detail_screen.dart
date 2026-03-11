import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late NewsModel _currentNews;
  bool _isLoading = false;
  String? _error;

  // Premium Theme Colors matching NewsScreen
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF);

  @override
  void initState() {
    super.initState();
    _currentNews = widget.news;
    if (_currentNews.content == null || _currentNews.content!.isEmpty) {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await ApiService().getNewsDetail(_currentNews.id);
      setState(() {
        _currentNews = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Không thể tải nội dung chi tiết. Vui lòng thử lại.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          _buildGlassHeader(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: _accentColor))
                : _error != null
                    ? _buildErrorPlaceholder()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_currentNews.category != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _accentColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _accentColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  _currentNews.category!.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              _currentNews.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                                color: _primaryColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 16, color: Colors.blueGrey.shade400),
                                const SizedBox(width: 6),
                                Text(
                                  _currentNews.time,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.blueGrey.shade600,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.remove_red_eye_rounded, size: 16, color: Colors.blueGrey.shade400),
                                const SizedBox(width: 6),
                                Text(
                                  '${_currentNews.views} xem',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.blueGrey.shade600,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (_currentNews.imageUrl != null)
                              Container(
                                height: 220,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(_currentNews.imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (_currentNews.imageUrl != null) const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentNews.description,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: _primaryColor.withOpacity(0.8),
                                      height: 1.6,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Divider(color: Color(0xFFF0F4F8), thickness: 2),
                                  ),
                                  MarkdownBody(
                                    data: _currentNews.content ?? "Nội dung chi tiết bài báo đang được cập nhật.",
                                    styleSheet: MarkdownStyleSheet(
                                      p: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade800,
                                        height: 1.7,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      h1: GoogleFonts.plusJakartaSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: _primaryColor,
                                        height: 1.4,
                                      ),
                                      h2: GoogleFonts.plusJakartaSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: _primaryColor,
                                        height: 1.4,
                                      ),
                                      h3: GoogleFonts.plusJakartaSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: _primaryColor,
                                        height: 1.4,
                                      ),
                                      listBullet: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        color: Colors.blueGrey.shade800,
                                      ),
                                      strong: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        color: _primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accentColor, const Color(0xFF4A9EAD)],
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
              'Chi Tiết Tin Tức',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
            Icon(Icons.error_outline_rounded, size: 80, color: Colors.redAccent.withOpacity(0.7)),
            const SizedBox(height: 20),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Thử lại',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
