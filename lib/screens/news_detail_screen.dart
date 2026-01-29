import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    _currentNews = widget.news;
    if (_currentNews.content == null) {
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
      setState(() {
        _error = "Không thể tải nội dung chi tiết. Vui lòng thử lại.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchDetail,
                        child: const Text("Thử lại"),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentNews.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF73C6D9).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _currentNews.category!,
                            style: const TextStyle(
                              color: Color(0xFF73C6D9),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        _currentNews.title,
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            _currentNews.time,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const Spacer(),
                          const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentNews.views} xem',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_currentNews.imageUrl != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(_currentNews.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        _currentNews.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _currentNews.content ?? "Nội dung chi tiết bài báo đang được cập nhật.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
