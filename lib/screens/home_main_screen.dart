import 'package:flutter/material.dart';
import 'chat_ai_screen.dart';
import 'discover_screen.dart';
import 'notification_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import 'health_assessment_screen.dart';
import '../services/api_service.dart';
import '../models/feature_model.dart';
import '../models/news_model.dart';
import '../widgets/ai_summary_dialog.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  final Color _primaryColor = const Color(0xFF73C6D9);
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;

  List<FeatureModel> _features = [];
  List<NewsModel> _news = [];
  bool _isLoadingFeatures = true;
  bool _isLoadingNews = true;
  String? _errorFeatures;
  String? _errorNews;

  final List<Map<String, String>> _dailyTips = [
    {
      "title": "Uống Đủ Nước Mỗi Ngày",
      "content": "Uống ít nhất 8 cốc nước mỗi ngày giúp cơ thể duy trì độ ẩm, hỗ trợ tiêu hóa và làm đẹp da."
    },
    {
      "title": "Ngủ Đủ Giấc",
      "content": "Ngủ 7-8 tiếng mỗi đêm giúp cơ thể phục hồi năng lượng, tăng cường hệ miễn dịch và cải thiện trí nhớ."
    },
    {
      "title": "Ăn Nhiều Rau Xanh",
      "content": "Bổ sung rau xanh vào bữa ăn hàng ngày giúp cung cấp vitamin, khoáng chất và chất xơ cần thiết cho cơ thể."
    },
    {
      "title": "Tập Thể Dục Đều Đặn",
      "content": "Dành ít nhất 30 phút mỗi ngày để vận động nhẹ nhàng như đi bộ, yoga giúp cải thiện sức khỏe tim mạch."
    },
    {
      "title": "Giảm Stress",
      "content": "Dành thời gian thư giãn, nghe nhạc hoặc thiền để giảm căng thẳng và cải thiện tinh thần."
    },
    {
      "title": "Hạn Chế Đường",
      "content": "Giảm lượng đường tiêu thụ giúp giảm nguy cơ béo phì, tiểu đường và các bệnh tim mạch."
    },
    {
      "title": "Khám Sức Khỏe Định Kỳ",
      "content": "Thăm khám bác sĩ định kỳ 6 tháng/lần để phát hiện sớm các vấn đề sức khỏe tiềm ẩn."
    },
  ];

  void _showDailyTipDialog(BuildContext context) {
    if (_dailyTips.isEmpty) return;
    
    final int tipIndex = DateTime.now().day % _dailyTips.length;
    final Map<String, String> currentTip = _dailyTips[tipIndex];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800), // Orange
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Mẹo Sức Khỏe Hôm Nay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTip['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentTip['content']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.orange[300]),
                        const SizedBox(width: 6),
                        Text(
                          "Cập nhật hôm nay",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Footer Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Đã hiểu",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadFeatures();
    _loadNews();
  }

  Future<void> _loadFeatures() async {
    setState(() {
      _isLoadingFeatures = true;
      _errorFeatures = null;
    });

    try {
      final features = await _apiService.getHomeFeatures();
      setState(() {
        _features = features;
        _isLoadingFeatures = false;
      });
    } catch (e) {
      setState(() {
        _errorFeatures = e.toString();
        _isLoadingFeatures = false;
        // Fallback to mock data if API fails
        _features = [
          FeatureModel(
            id: 'feature-1',
            title: 'Tìm hiểu',
            icon: 'search',
            order: 1,
          ),
          FeatureModel(
            id: 'feature-2',
            title: 'Đánh giá sức khỏe',
            icon: 'monitor_heart_outlined',
            order: 2,
          ),
          FeatureModel(
            id: 'feature-3',
            title: 'Mẹo hôm nay',
            icon: 'tips_and_updates_outlined',
            order: 3,
          ),
        ];
      });
    }
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoadingNews = true;
      _errorNews = null;
    });

    try {
      final newsResponse = await _apiService.getNews(page: 1, limit: 3);
      setState(() {
        _news = newsResponse.items;
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _errorNews = e.toString();
        _isLoadingNews = false;
        // Fallback to empty list if API fails
        _news = [];
      });
    }
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'search':
        return Icons.search;
      case 'monitor_heart_outlined':
        return Icons.monitor_heart_outlined;
      case 'tips_and_updates_outlined':
        return Icons.tips_and_updates_outlined;
      default:
        return Icons.info_outline;
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
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGradientAppBar(),
              const SizedBox(height: 20),
              _buildSectionHeader('Chức năng'),
              _isLoadingFeatures
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: _features
                            .map(
                              (item) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (item.title == 'Tìm hiểu') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const DiscoverScreen(),
                                          ),
                                        );
                                      } else if (item.title == 'Đánh giá sức khỏe') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const HealthAssessmentScreen(),
                                          ),
                                        );
                                      } else if (item.title == 'Mẹo hôm nay') {
                                        _showDailyTipDialog(context);
                                      }
                                    },
                                    child: _FeatureCard(
                                      feature: item,
                                      primaryColor: _primaryColor,
                                      getIcon: _getIconFromString,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
              const SizedBox(height: 28),
              _buildNewsHeader(),
              _isLoadingNews
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _news.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'Không có tin tức',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: _news
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: InkWell(
                                      onTap: () => showAISummaryDialog(context, item),
                                      borderRadius: BorderRadius.circular(16),
                                      child: _NewsCard(
                                        news: item,
                                        primaryColor: _primaryColor,
                                        formatViews: _formatViews,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildGradientAppBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor,
            const Color(0xFF9DD9E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HealthCare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Xin chào',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNewsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tin Tức Y Tế',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NewsScreen(),
                ),
              );
            },
            child: const Text(
              'Xem tất cả >',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF73C6D9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChatAIScreen()),
          );
        } else if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationScreen()),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey.shade500,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Thông báo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.feature,
    required this.primaryColor,
    required this.getIcon,
  });

  final FeatureModel feature;
  final Color primaryColor;
  final IconData Function(String) getIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(feature.icon),
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            feature.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.news,
    required this.primaryColor,
    required this.formatViews,
  });

  final NewsModel news;
  final Color primaryColor;
  final String Function(int) formatViews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: news.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      news.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          color: primaryColor.withOpacity(0.5),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.image,
                    color: primaryColor.withOpacity(0.5),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      news.time,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${formatViews(news.views)} lượt xem',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey.shade700,
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
}

