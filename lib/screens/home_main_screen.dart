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
import 'simulation_history_screen.dart';
import '../services/api_service.dart';
import '../models/feature_model.dart';
import '../models/news_model.dart';
import '../models/home_model.dart';
import '../widgets/ai_summary_dialog.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen>
    with TickerProviderStateMixin {
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
  bool _isLoadingHistory = true;
  Map<String, dynamic>? _lastSimulation;

  String _userFullName = '';
  String _gender = 'Khác';

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
      _gender = prefs.getString('gender') ?? 'Khác';
    });

    _loadFeatures();
    _loadNews();
    _loadDailyTips();
    _loadSimulationHistory();
  }

  Future<void> _loadSimulationHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final history = await _apiService.getSimulationHistory();
      // Chỉ lấy mô phỏng tự nhiên (hunault) cho phần lộ trình
      final hunaultHistory = history
          .where((s) => s['model_id'] == 'hunault')
          .toList();
      if (hunaultHistory.isNotEmpty) {
        setState(() {
          _lastSimulation = hunaultHistory.first;
          _isLoadingHistory = false;
        });
      } else {
        setState(() {
          _lastSimulation = null;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingHistory = false);
    }
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
          FeatureModel(
            id: '2',
            title: 'Gợi ý',
            icon: 'medical_services_outlined',
            order: 2,
          ),
          FeatureModel(
            id: '3',
            title: 'Mẹo',
            icon: 'tips_and_updates_outlined',
            order: 3,
          ),
        ];
      });
    }
  }

  Future<void> _loadNews() async {
    setState(() => _isLoadingNews = true);
    try {
      final response = await _apiService.getNews(
        page: 1,
        limit: 4,
      ); // Fetch 4 for new layout
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
                  colors: [
                    _accentColor,
                    const Color(0xFF4A8E96),
                  ], // Vibrant gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
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
                          BoxShadow(
                            color: _darkShadow,
                            blurRadius: 10,
                            offset: const Offset(4, 4),
                          ),
                          BoxShadow(
                            color: _lightShadow,
                            blurRadius: 10,
                            offset: const Offset(-4, -4),
                          ),
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
            reverseDuration: const Duration(
              milliseconds: 300,
            ), // Rời đi thì nhanh hơn
            switchInCurve: Curves.easeOutQuart,
            switchOutCurve: Curves.easeInQuart,
            transitionBuilder: (child, animation) {
              // Hiệu ứng Fade mờ dần
              final fade = FadeTransition(opacity: animation, child: child);

              // Trượt tà tà từ dưới lên
              final slide = SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.1), // Rớt sâu xuống một tí
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: fade,
              );

              // Cùng lúc đó hình ảnh phình to (Scale) nhẹ
              return ScaleTransition(
                scale:
                    Tween<double>(
                      begin: 0.96, // Phóng từ 96%
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
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
                  _buildTimelineSection(),
                  const SizedBox(height: 40),
                  _buildSectionTitle('Tin tức y tế', isInteractive: true),
                  const SizedBox(height: 20),
                  _buildModernNewsLayout(), // The requested new layout
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lộ trình của bạn',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            if (_lastSimulation != null)
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SimulationHistoryScreen(),
                  ),
                ),
                child: Text(
                  'Xem lịch sử',
                  style: GoogleFonts.plusJakartaSans(
                    color: _accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        _isLoadingHistory
            ? const Center(child: CircularProgressIndicator())
            : _lastSimulation == null
            ? _buildEmptyTimelineCard()
            : _buildActiveTimelineCard(),
      ],
    );
  }

  Widget _buildEmptyTimelineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _darkShadow,
            blurRadius: 15,
            offset: const Offset(8, 8),
          ),
          BoxShadow(
            color: _lightShadow,
            blurRadius: 15,
            offset: const Offset(-8, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_graph_rounded,
              color: _accentColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Chưa có dữ liệu lộ trình",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Hãy thực hiện mô phỏng để AI phân tích lộ trình sinh sản dành riêng cho bạn.",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: Colors.black.withOpacity(0.5),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                setState(() => _selectedIndex = 2), // Go to Simulation Page
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              "Thử ngay",
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimelineCard() {
    final result = _lastSimulation!['result'] ?? {};
    final Map<String, dynamic>? patientGroup = result['patient_group'];
    final String groupName = patientGroup?['name'] ?? "Lộ trình của bạn";
    final String colorHex = patientGroup?['color'] ?? "#1D4E56";
    final Color groupColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () => _showTimelineDetailDialog(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [groupColor, groupColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: groupColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nhóm hiện tại",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        groupName,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(patientGroup?['icon'] ?? 'stars_rounded'),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Xem lộ trình hành động chi tiết",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite_rounded': return Icons.favorite_rounded;
      case 'psychology_rounded': return Icons.psychology_rounded;
      case 'medical_services_rounded': return Icons.medical_services_rounded;
      case 'stars_rounded': return Icons.stars_rounded;
      default: return Icons.bubble_chart_rounded;
    }
  }

  void _showTimelineDetailDialog() {
    final result = _lastSimulation!['result'] ?? {};
    final int breakPoint = result['break_point'] ?? 12;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, const Color(0xFF2D6A73)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Lộ trình tối ưu hóa",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      'Tháng 1 - Tháng ${breakPoint ~/ 2}',
                      'Giai đoạn Vàng: Tự nhiên',
                      'Tập trung vào dinh dưỡng, bổ sung vitamin cho cả hai vợ chồng.',
                      Icons.wb_sunny_rounded,
                      Colors.green,
                      true,
                    ),
                    _buildTimelineStep(
                      'Tháng ${breakPoint ~/ 2 + 1} - Tháng $breakPoint',
                      'Giai đoạn Lưu ý: Kiểm tra',
                      'Nếu chưa có tin vui, hai bạn nên thực hiện các kiểm tra sức khỏe cơ bản.',
                      Icons.visibility_rounded,
                      Colors.orange,
                      true,
                    ),
                    _buildTimelineStep(
                      'Sau tháng $breakPoint',
                      'Giai đoạn Hành động',
                      'Đã đến lúc cần phác đồ chuyên biệt từ bác sĩ để rút ngắn hành trình.',
                      Icons.medical_services_rounded,
                      Colors.redAccent,
                      false,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        "Đã rõ lộ trình",
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String time, String title, String desc, IconData icon, Color color, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 50,
                color: color.withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.blueGrey.shade600,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildTimelineChart(List<dynamic> data, int breakPoint) {
    List<FlSpot> avgSpots = data
        .map(
          (d) => FlSpot(
            (d['month'] as num).toDouble(),
            (d['cumulative_probability'] as num).toDouble(),
          ),
        )
        .toList();

    List<FlSpot> lowSpots = [];
    List<FlSpot> highSpots = [];

    // Prepare low and high boundaries
    if (data.isNotEmpty && data.first.containsKey('prob_low')) {
      lowSpots = data
          .map(
            (d) => FlSpot(
              (d['month'] as num).toDouble(),
              (d['prob_low'] as num).toDouble(),
            ),
          )
          .toList();
      highSpots = data
          .map(
            (d) => FlSpot(
              (d['month'] as num).toDouble(),
              (d['prob_high'] as num).toDouble(),
            ),
          )
          .toList();
    }

    final avgLine = LineChartBarData(
      spots: avgSpots,
      isCurved: true,
      color: Colors.white,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: highSpots.isEmpty
          ? BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.4),
                  _accentColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          : BarAreaData(show: false),
    );

    final lowLine = LineChartBarData(
      spots: lowSpots,
      isCurved: true,
      color: Colors.transparent,
      barWidth: 0,
      dotData: const FlDotData(show: false),
    );

    final highLine = LineChartBarData(
      spots: highSpots,
      isCurved: true,
      color: Colors.transparent,
      barWidth: 0,
      dotData: const FlDotData(show: false),
    );

    final List<LineChartBarData> barDataList = highSpots.isNotEmpty
        ? [avgLine, lowLine, highLine]
        : [avgLine];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          verticalInterval: 6,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: _darkShadow.withOpacity(0.5), strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: _darkShadow.withOpacity(0.5), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 6,
              getTitlesWidget: (value, meta) => Text(
                'T${value.toInt()}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 42,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: 24,
        minY: 0,
        maxY: 100,
        lineBarsData: barDataList,
        betweenBarsData: highSpots.isNotEmpty
            ? [
                BetweenBarsData(
                  fromIndex: 1,
                  toIndex: 2,
                  color: Colors.white.withOpacity(0.3),
                ),
              ]
            : [],
        extraLinesData: ExtraLinesData(
          verticalLines: [
            VerticalLine(
              x: breakPoint.toDouble(),
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 2,
              dashArray: [5, 5],
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                labelResolver: (_) => "Điểm gãy",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficLightLegend(int breakPoint) {
    return Column(
      children: [
        _buildLegendItem(
          Colors.green,
          "Vùng thoải mái (1-${breakPoint - 2} tháng): Hãy cứ thả tự nhiên.",
        ),
        const SizedBox(height: 12),
        _buildLegendItem(
          Colors.orange,
          "Vùng lưu ý (${breakPoint - 1}-${breakPoint + 2} tháng): Tỷ lệ bắt đầu chững lại.",
        ),
        const SizedBox(height: 12),
        _buildLegendItem(
          Colors.red,
          "Vùng hành động (Từ tháng $breakPoint): Thời điểm vàng để đặt lịch khám.",
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: _primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakPointAlert(int breakPoint) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.red),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "AI dự báo bạn nên tối ưu hóa thời gian trong 6-12 tháng đầu. Sau tháng $breakPoint, hãy cân nhắc can thiệp y tế.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
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
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        _gender == 'Nam'
                            ? Icons.face
                            : (_gender == 'Nữ' ? Icons.face_3 : Icons.person),
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _gender == 'Nam'
                                ? Icons.male
                                : (_gender == 'Nữ'
                                      ? Icons.female
                                      : Icons.person),
                            color: _gender == 'Nam'
                                ? Colors.blue.shade100
                                : (_gender == 'Nữ'
                                      ? Colors.pink.shade200
                                      : Colors.white),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Hello 👋",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  ),
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _darkShadow,
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: _lightShadow,
                    blurRadius: 6,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Tất cả',
                    style: GoogleFonts.plusJakartaSans(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: _primaryColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFunctionGrid() {
    if (_isLoadingFeatures)
      return const Center(child: CircularProgressIndicator());

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
              accentColor: idx == 0
                  ? _accentColor
                  : idx == 1
                  ? const Color(0xFF7CB342)
                  : const Color(0xFF42A5F5),
              primaryColor: _primaryColor,
              onTap: () {
                if (feature.title.contains('Tìm hiểu')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiscoverScreen()),
                  );
                } else if (feature.title.contains('Gợi ý')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HospitalListScreen(),
                    ),
                  );
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

    final displayNews = _news.take(5).toList();

    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemCount: displayNews.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 220,
              child: _NeumorphicGridNewsCard(
                news: displayNews[index],
                bgColor: _bgColor,
                lightShadow: _lightShadow,
                darkShadow: _darkShadow,
                brandColor: _primaryColor,
                onTap: () => showAISummaryDialog(context, displayNews[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
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

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
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
                  BoxShadow(
                    color: _darkShadow,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: _lightShadow,
                    blurRadius: 4,
                    offset: const Offset(-2, -2),
                  ),
                ],
              )
            : const BoxDecoration(),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? _primaryColor : Colors.grey.withOpacity(0.7),
        ),
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
    required this.onTap,
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
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 8,
        ), // Reduced vertical stretch
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    color: widget.darkShadow,
                    blurRadius: 12,
                    offset: const Offset(6, 6),
                  ),
                  BoxShadow(
                    color: widget.lightShadow,
                    blurRadius: 12,
                    offset: const Offset(-6, -6),
                  ),
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
                        BoxShadow(
                          color: widget.darkShadow,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                        BoxShadow(
                          color: widget.lightShadow,
                          blurRadius: 4,
                          offset: const Offset(-2, -2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: widget.darkShadow,
                          blurRadius: 6,
                          offset: const Offset(4, 4),
                        ),
                        BoxShadow(
                          color: widget.lightShadow,
                          blurRadius: 6,
                          offset: const Offset(-4, -4),
                        ),
                      ],
              ),
              child: Icon(
                _getIcon(widget.feature.icon),
                color: widget.accentColor,
                size: 28,
              ),
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
                letterSpacing: -0.2,
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
    required this.onTap,
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
            BoxShadow(
              color: darkShadow,
              blurRadius: 12,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: lightShadow,
              blurRadius: 12,
              offset: const Offset(-6, -6),
            ),
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
                    BoxShadow(
                      color: darkShadow.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: news.imageUrl != null
                      ? Image.network(news.imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                          ),
                        ),
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
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  news.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
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
    required this.onTap,
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
            BoxShadow(
              color: darkShadow,
              blurRadius: 12,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: lightShadow,
              blurRadius: 12,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: news.imageUrl != null
                      ? Image.network(news.imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                          ),
                        ),
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
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetaInfo(
                        Icons.access_time_filled_rounded,
                        news.time,
                      ),
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
