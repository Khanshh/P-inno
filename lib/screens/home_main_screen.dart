import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_ai_screen.dart';
import 'discover_screen.dart';
import 'notification_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import 'health_assessment_screen.dart';
import 'simulation_screen.dart';
import 'simulation_intro_screen.dart';
import 'hospital_list_screen.dart';
import '../services/api_service.dart';
import '../models/feature_model.dart';
import '../models/news_model.dart';
import '../models/home_model.dart';
import '../widgets/ai_summary_dialog.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  // Constants for Premium UI
  final double _horizontalPadding = 20.0;
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Light Teal for accents

  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;

  List<FeatureModel> _features = [];
  List<NewsModel> _news = [];
  List<DailyTipModel> _dailyTips = [];
  bool _isLoadingFeatures = true;
  bool _isLoadingNews = true;
  bool _isLoadingTips = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadFeatures();
    _loadNews();
    _loadDailyTips();
  }

  Future<void> _loadFeatures() async {
    setState(() => _isLoadingFeatures = true);
    try {
      _features = await _apiService.getHomeFeatures();
      setState(() => _isLoadingFeatures = false);
    } catch (e) {
      setState(() {
        _isLoadingFeatures = false;
        _features = [
          FeatureModel(id: '1', title: 'Tìm hiểu', icon: 'search', order: 1),
          FeatureModel(id: '2', title: 'Gợi ý', icon: 'medical_services_outlined', order: 2),
          FeatureModel(id: '3', title: 'Mẹo', icon: 'tips_and_updates_outlined', order: 3),
        ];
      });
    }
  }

  Future<void> _loadNews() async {
    setState(() => _isLoadingNews = true);
    try {
      final response = await _apiService.getNews(page: 1, limit: 3);
      setState(() {
        _news = response.items;
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() => _isLoadingNews = false);
    }
  }

  Future<void> _loadDailyTips() async {
    setState(() => _isLoadingTips = true);
    try {
      _dailyTips = await _apiService.getDailyTips();
      setState(() => _isLoadingTips = false);
    } catch (e) {
      setState(() => _isLoadingTips = false);
    }
  }

  void _showDailyTipDialog(BuildContext context) {
    if (_dailyTips.isEmpty) return;
    final tip = _dailyTips[DateTime.now().day % _dailyTips.length];
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Text("Mẹo hôm nay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(tip.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(tip.content, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Đã hiểu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const ChatAIScreen(),
      const SimulationIntroScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF), 
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadData,
        color: _primaryColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSectionTitle('Chức năng'),
              const SizedBox(height: 16),
              _buildFunctionCards(),
              const SizedBox(height: 28), // Enhanced spacing per request
              _buildNewsHeader(),
              const SizedBox(height: 16),
              _buildNewsFeed(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6), // Added specific offset
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2), // Border wrapper
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
              ]
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chào buổi sáng 👋",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4), // Required spacing
                Text(
                  "Nguyễn Văn A",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D4E56),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
            icon: Icon(Icons.notifications_none_rounded, color: _primaryColor, size: 28), // Size 28
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1D4E56),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildFunctionCards() {
    if (_isLoadingFeatures) return const Center(child: CircularProgressIndicator());
    
    // Different pastel colors for each card
    final List<Color> pastelColors = [
      const Color(0xFFE0F2F1), // Teal pastel
      const Color(0xFFF1F8E9), // Mint pastel
      const Color(0xFFE3F2FD), // Light Blue pastel
    ];

    int index = 0;
    return Row(
      children: _features.map((feature) {
        final cardColor = pastelColors[index % pastelColors.length];
        final iconColor = [const Color(0xFF00897B), const Color(0xFF689F38), const Color(0xFF1E88E5)][index % 3];
        index++;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _FeatureCard(
              feature: feature,
              iconBgColor: cardColor,
              iconColor: iconColor,
              onTap: () {
                if (feature.title.contains('Tìm hiểu')) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscoverScreen()));
                } else if (feature.title.contains('Gợi ý')) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HospitalListScreen()));
                } else if (feature.title.contains('Mẹo')) {
                  _showDailyTipDialog(context);
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Tin tức y tế'),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
          child: Row(
            children: [
              Text(
                'Xem tất cả',
                style: TextStyle(color: _accentColor, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14, color: _accentColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsFeed() {
    if (_isLoadingNews) return const Center(child: CircularProgressIndicator());
    if (_news.isEmpty) return const Center(child: Text("Không có tin tức"));
    return Column(
      children: _news.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _NewsCard(
          news: item,
          onTap: () => showAISummaryDialog(context, item),
        ),
      )).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        selectedIconTheme: const IconThemeData(size: 28), // Visible feedback
        unselectedIconTheme: const IconThemeData(size: 26), // Increased default size
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat AI'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: 'Mô phỏng'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final FeatureModel feature;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.feature, 
    required this.iconBgColor, 
    required this.iconColor, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor, // Pastel variant
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(feature.icon), color: iconColor, size: 32), // Size 32
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, // Standardized 14
                fontWeight: FontWeight.bold, 
                color: const Color(0xFF1D4E56)
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    if (iconName.contains('search')) return Icons.search_rounded;
    if (iconName.contains('medical')) return Icons.local_hospital_rounded;
    if (iconName.contains('tips')) return Icons.tips_and_updates_rounded;
    return Icons.widgets_rounded;
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onTap;

  const _NewsCard({required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14, // Increased blur
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded 12
              child: Container(
                width: 96,
                height: 96,
                color: Colors.grey[200],
                child: news.imageUrl != null 
                  ? Image.network(news.imageUrl!, fit: BoxFit.cover) // BoxFit.cover
                  : const Icon(Icons.image_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xFF1D4E56), 
                      height: 1.3
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        news.time,
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.grey.withOpacity(0.7), // Contrasted grey
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.remove_red_eye_rounded, size: 14, color: Colors.grey.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        '${news.views}',
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
