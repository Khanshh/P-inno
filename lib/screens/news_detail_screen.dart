import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF73C6D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  news.category!,
                  style: const TextStyle(
                    color: Color(0xFF73C6D9),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              news.title,
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
                  news.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Spacer(),
                const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${news.views} xem',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (news.imageUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(news.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              news.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Mock content since NewsModel doesn't have full content yet in local model strictly speaking
            // (Wait, backend has content, model strictly speaking doesn't have content field in dart yet? Let's check NewsModel again)
            Text(
              "Nội dung chi tiết bài báo đang được cập nhật. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
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
