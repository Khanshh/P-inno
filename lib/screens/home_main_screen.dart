import 'package:flutter/material.dart';
import 'chat_ai_screen.dart';
import 'discover_screen.dart';
import 'notification_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart';
import '../models/feature_model.dart';
import '../models/news_model.dart';

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
                                    child: _NewsCard(
                                      news: item,
                                      primaryColor: _primaryColor,
                                      formatViews: _formatViews,
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

