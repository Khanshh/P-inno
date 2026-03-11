import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _HomeMainScreenState extends State<HomeMainScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  // Brand Colors
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF6FB7C6); // Light Teal
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF); // Matches Onboarding
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); // Soft blue-grey shadow

  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;

  List<FeatureModel> _features = [];
  List<NewsModel> _news = [];
  List<DailyTipModel> _dailyTips = [];
  bool _isLoadingFeatures = true;
  bool _isLoadingNews = true;
  bool _isLoadingTips = true;
  
  String _userFullName = '';

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadData();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userFullName = prefs.getString('user_full_name') ?? 'Khách';
    });
    
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
      final response = await _apiService.getNews(page: 1, limit: 4); // Fetch 4 for new layout
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
        backgroundColor: _bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accentColor, const Color(0xFF4A8E96)], // Vibrant gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Mẹo hôm nay",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    tip.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: _primaryColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tip.content,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _bgColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: _darkShadow, blurRadius: 10, offset: const Offset(4, 4)),
                          BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-4, -4)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Đã hiểu",
                        style: GoogleFonts.plusJakartaSans(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
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
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 650),
            reverseDuration: const Duration(milliseconds: 300), // Rời đi thì nhanh hơn
            switchInCurve: Curves.easeOutQuart,
            switchOutCurve: Curves.easeInQuart,
            transitionBuilder: (child, animation) {
              // Hiệu ứng Fade mờ dần
              final fade = FadeTransition(opacity: animation, child: child);
              
              // Trượt tà tà từ dưới lên
              final slide = SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1), // Rớt sâu xuống một tí
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: fade,
              );

              // Cùng lúc đó hình ảnh phình to (Scale) nhẹ
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.96, // Phóng từ 96%
                  end: 1.0,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: slide,
              );
            },
            child: SizedBox(
              key: ValueKey<int>(_selectedIndex),
              child: pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100 + (50 * _backgroundController.value),
              left: -150 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFE0F7F7).withOpacity(0.6)),
            ),
            Positioned(
              top: 300 - (20 * _backgroundController.value),
              right: -120 + (40 * _backgroundController.value),
              child: _buildOrb(380, const Color(0xFFFAF1E2).withOpacity(0.5)),
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

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: _primaryColor,
      backgroundColor: _bgColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildGlassHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildSectionTitle('Chức năng'),
                  const SizedBox(height: 20),
                  _buildFunctionGrid(),
                  const SizedBox(height: 40),
                  _buildSectionTitle('Tin tức y tế', isInteractive: true),
                  const SizedBox(height: 20),
                  _buildModernNewsLayout(), // The requested new layout
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
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
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello 👋",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userFullName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isInteractive = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        if (isInteractive)
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: _darkShadow, blurRadius: 6, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-2, -2)),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Tất cả',
                    style: GoogleFonts.plusJakartaSans(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 17, color: _primaryColor),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFunctionGrid() {
    if (_isLoadingFeatures) return const Center(child: CircularProgressIndicator());
    
    return Row(
      children: _features.asMap().entries.map((entry) {
        final int idx = entry.key;
        final feature = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: idx == 0 ? 0 : 8,
              right: idx == _features.length - 1 ? 0 : 8,
            ),
            child: _NeumorphicFeatureCard(
              feature: feature,
              bgColor: _bgColor,
              lightShadow: _lightShadow,
              darkShadow: _darkShadow,
              accentColor: idx == 0 ? _accentColor : idx == 1 ? const Color(0xFF7CB342) : const Color(0xFF42A5F5),
              primaryColor: _primaryColor,
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

  Widget _buildModernNewsLayout() {
    if (_isLoadingNews) return const Center(child: CircularProgressIndicator());
    if (_news.isEmpty) return const Center(child: Text("Không có tin tức"));

    final displayNews = _news.take(4).toList();
    // Layout: 2 Rows, 2 Columns (Grid)
    List<Widget> rows = [];
    for (int i = 0; i < displayNews.length; i += 2) {
      Widget leftCard = Expanded(
        child: _NeumorphicGridNewsCard(
          news: displayNews[i],
          bgColor: _bgColor,
          lightShadow: _lightShadow,
          darkShadow: _darkShadow,
          brandColor: _primaryColor,
          onTap: () => showAISummaryDialog(context, displayNews[i]),
        ),
      );

      Widget rightCard;
      if (i + 1 < displayNews.length) {
        rightCard = Expanded(
          child: _NeumorphicGridNewsCard(
            news: displayNews[i + 1],
            bgColor: _bgColor,
            lightShadow: _lightShadow,
            darkShadow: _darkShadow,
            brandColor: _primaryColor,
            onTap: () => showAISummaryDialog(context, displayNews[i + 1]),
          ),
        );
      } else {
        rightCard = const Expanded(child: SizedBox()); // Empty space
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftCard,
              const SizedBox(width: 16),
              rightCard,
            ],
          ),
        )
      );
    }
    return Column(children: rows);
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, -10)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: _bgColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        selectedFontSize: 15,
        unselectedFontSize: 15,
        elevation: 0,
        items: [
          _buildNavItem(Icons.home_rounded, 'Trang chủ', 0),
          _buildNavItem(Icons.chat_bubble_rounded, 'Chat AI', 1),
          _buildNavItem(Icons.auto_graph_rounded, 'Mô phỏng', 2),
          _buildNavItem(Icons.person_rounded, 'Hồ sơ', 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: isActive
            ? BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: _darkShadow, blurRadius: 4, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                ],
              )
            : const BoxDecoration(),
        child: Icon(icon, size: 24, color: isActive ? _primaryColor : Colors.grey.withOpacity(0.7)),
      ),
      label: label,
    );
  }
}

// ----------------------------------------------------------------------
// COMPONENTS
// ----------------------------------------------------------------------

class _NeumorphicFeatureCard extends StatefulWidget {
  final FeatureModel feature;
  final Color bgColor;
  final Color lightShadow;
  final Color darkShadow;
  final Color accentColor;
  final Color primaryColor;
  final VoidCallback onTap;

  const _NeumorphicFeatureCard({
    required this.feature, 
    required this.bgColor, 
    required this.lightShadow, 
    required this.darkShadow,
    required this.accentColor,
    required this.primaryColor,
    required this.onTap
  });

  @override
  State<_NeumorphicFeatureCard> createState() => _NeumorphicFeatureCardState();
}

class _NeumorphicFeatureCardState extends State<_NeumorphicFeatureCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8), // Reduced vertical stretch
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isPressed 
            ? null 
            : [
                BoxShadow(color: widget.darkShadow, blurRadius: 12, offset: const Offset(6, 6)),
                BoxShadow(color: widget.lightShadow, blurRadius: 12, offset: const Offset(-6, -6)),
              ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: _isPressed 
                  ? [
                      BoxShadow(color: widget.darkShadow, blurRadius: 4, offset: const Offset(2, 2)),
                      BoxShadow(color: widget.lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                    ]
                  : [
                      BoxShadow(color: widget.darkShadow, blurRadius: 6, offset: const Offset(4, 4)),
                      BoxShadow(color: widget.lightShadow, blurRadius: 6, offset: const Offset(-4, -4)),
                    ],
              ),
              child: Icon(_getIcon(widget.feature.icon), color: widget.accentColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              widget.feature.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17, 
                fontWeight: FontWeight.w800, 
                color: widget.primaryColor,
                letterSpacing: -0.2
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    if (iconName.contains('search')) return Icons.auto_stories_rounded;
    if (iconName.contains('medical')) return Icons.health_and_safety_rounded;
    if (iconName.contains('tips')) return Icons.lightbulb_outline_rounded;
    return Icons.widgets_rounded;
  }
}

// ----------------------------------------------------------------------
// Grid News Layout (Square Aspect)
// ----------------------------------------------------------------------
class _NeumorphicGridNewsCard extends StatelessWidget {
  final NewsModel news;
  final Color bgColor;
  final Color lightShadow;
  final Color darkShadow;
  final Color brandColor;
  final VoidCallback onTap;

  const _NeumorphicGridNewsCard({
    required this.news, 
    required this.bgColor, 
    required this.lightShadow, 
    required this.darkShadow,
    required this.brandColor,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250, // Fixed height for Grid items
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: darkShadow, blurRadius: 12, offset: const Offset(6, 6)),
            BoxShadow(color: lightShadow, blurRadius: 12, offset: const Offset(-6, -6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: darkShadow.withOpacity(0.5), blurRadius: 6, offset: const Offset(2, 2)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: news.imageUrl != null 
                    ? Image.network(news.imageUrl!, fit: BoxFit.cover) 
                    : Container(color: Colors.grey[300], child: const Icon(Icons.image_outlined, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              news.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17, 
                fontWeight: FontWeight.w800, 
                color: brandColor,
                height: 1.3
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time_filled_rounded, size: 15, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  news.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, 
                    color: Colors.grey.shade600, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Horizontal Row News Layout
// ----------------------------------------------------------------------
class _NeumorphicRowNewsCard extends StatelessWidget {
  final NewsModel news;
  final Color bgColor;
  final Color lightShadow;
  final Color darkShadow;
  final Color brandColor;
  final VoidCallback onTap;

  const _NeumorphicRowNewsCard({
    required this.news, 
    required this.bgColor, 
    required this.lightShadow, 
    required this.darkShadow,
    required this.brandColor,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: darkShadow, blurRadius: 12, offset: const Offset(6, 6)),
            BoxShadow(color: lightShadow, blurRadius: 12, offset: const Offset(-6, -6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: darkShadow.withOpacity(0.4), blurRadius: 6, offset: const Offset(2, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: news.imageUrl != null 
                    ? Image.network(news.imageUrl!, fit: BoxFit.cover) 
                    : Container(color: Colors.grey[300], child: const Icon(Icons.image_outlined, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, 
                      fontWeight: FontWeight.w800, 
                      color: brandColor,
                      height: 1.3
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetaInfo(Icons.access_time_filled_rounded, news.time),
                      const SizedBox(width: 12),
                      _buildMetaInfo(Icons.visibility_rounded, '${news.views}'),
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

  Widget _buildMetaInfo(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15, 
            color: Colors.grey.shade600, 
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }
}
