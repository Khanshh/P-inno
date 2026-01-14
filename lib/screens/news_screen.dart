import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C6D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tin Tức Y Tế',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tất Cả Tin Tức',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5), // Light grey background for list
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Adjust for card height
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: _mockNews.length,
                itemBuilder: (context, index) {
                  return _NewsCard(news: _mockNews[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final Map<String, String> news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // No shadow or very light shadow as requested
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // To clip image corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              Container(
                height: 100, // Fixed height for image area
                width: double.infinity,
                color: Colors.grey[300], // Placeholder color
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        news['time']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        news['views']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
    );
  }
}

// Mock Data
final List<Map<String, String>> _mockNews = [
  {
    'title': 'Tầm quan trọng của giấc ngủ đối với sức khỏe',
    'description': 'Người trưởng thành cần từ 7-9 tiếng ngủ mỗi đêm để phục hồi cơ thể và tinh thần.',
    'time': '1 ngày trước',
    'views': '1.8k',
  },
  {
    'title': 'Bảo hiểm du lịch: Những điều cần biết',
    'description': 'Lợi ích của việc mua bảo hiểm khi đi du lịch nước ngoài và các rủi ro được bảo vệ.',
    'time': '2 ngày trước',
    'views': '2.1k',
  },
  {
    'title': 'Khí hậu Việt Nam theo mùa và ảnh hưởng sức khỏe',
    'description': 'Cách phòng tránh các bệnh thường gặp khi thời tiết thay đổi thất thường.',
    'time': '12 giờ trước',
    'views': '950',
  },
  {
    'title': 'Du lịch tiết kiệm: Bí quyết cho người mới',
    'description': 'Lên kế hoạch chi tiêu hợp lý để có chuyến đi trọn vẹn mà không lo về giá.',
    'time': '3 ngày trước',
    'views': '3.2k',
  },
  {
    'title': 'Tập thể dục buổi sáng có tốt không?',
    'description': 'Những lợi ích bất ngờ của việc vận động nhẹ nhàng vào khung giờ vàng buổi sáng.',
    'time': '5 giờ trước',
    'views': '1.5k',
  },
  {
    'title': 'Quản lý Stress trong công việc hiệu quả',
    'description': 'Các phương pháp đơn giản giúp giảm căng thẳng và tăng năng suất làm việc.',
    'time': '4 ngày trước',
    'views': '4.1k',
  },
  {
    'title': 'Chế độ ăn Eat Clean cho người bận rộn',
    'description': 'Gợi ý thực đơn nhanh gọn, đầy đủ dinh dưỡng cho dân văn phòng.',
    'time': '1 tuần trước',
    'views': '5.5k',
  },
  {
    'title': 'Lợi ích của việc uống đủ nước mỗi ngày',
    'description': 'Nước giúp thanh lọc cơ thể, làm đẹp da và hỗ trợ giảm cân hiệu quả.',
    'time': '1 ngày trước',
    'views': '800',
  },
];
