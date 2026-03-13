import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  String _userGender = 'Nữ';
  bool _isLoading = true;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9);
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadGender();
  }

  Future<void> _loadGender() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userGender = prefs.getString('gender') ?? 'Nữ';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      _buildProbabilityCard(),
                      const SizedBox(height: 24),
                      _buildBarChartCard(),
                      const SizedBox(height: 24),
                      _buildAgeInfluenceCard(),
                      const SizedBox(height: 24),
                      _buildInfluencingFactorsCard(),
                      const SizedBox(height: 24),
                      _buildPersonalizedSuggestionsCard(),
                      const SizedBox(height: 24),
                      _buildActionRoadmapCard(),
                      const SizedBox(height: 32),
                      _buildFooterButton(context),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
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
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 44), // Placeholder to keep title centered since there's a button on the right
          Expanded(
            child: Text(
              'Mô phỏng 3 tháng',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Card 1: Xác suất ước tính
  // ============================================================
  Widget _buildProbabilityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Xác suất ước tính',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '48% - 55%',
            style: GoogleFonts.plusJakartaSans(
              color: _primaryColor,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Khả năng có thai trong 3 tháng tới',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
                BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: _accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Độ tin cậy: Trung bình',
                  style: GoogleFonts.plusJakartaSans(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Card 2: So sánh phương pháp
  // ============================================================
  Widget _buildBarChartCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'So sánh phương pháp',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhấn vào cột để xem chi tiết',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),
          _buildBarChart(),
          const SizedBox(height: 28),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final List<_BarData> bars = [
      _BarData('Tự nhiên', 0.25, const Color(0xFF2C5F7C)),
      _BarData('KTPN', 0.35, const Color(0xFFE88D3F)),
      _BarData('IUI', 0.48, _accentColor),
      _BarData('IVF', 0.72, const Color(0xFF8B5CF6)),
      _BarData('ICSI', 0.65, const Color(0xFFEC4899)),
    ];

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((bar) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${(bar.value * 100).toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: bar.color,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 130 * bar.value,
                decoration: BoxDecoration(
                  color: bar.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(color: bar.color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                bar.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend() {
    final List<_LegendItem> items = [
      _LegendItem('Tự nhiên', const Color(0xFF2C5F7C)),
      _LegendItem('KTPN', const Color(0xFFE88D3F)),
      _LegendItem('IUI', _accentColor),
      _LegendItem('IVF', const Color(0xFF8B5CF6)),
      _LegendItem('ICSI', const Color(0xFFEC4899)),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: item.color.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 2)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ============================================================
  // Card 3: Ảnh hưởng theo tuổi
  // ============================================================
  Widget _buildAgeInfluenceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ảnh hưởng theo tuổi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tỷ lệ thành công theo độ tuổi',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          _buildAgeLineChart(),
          const SizedBox(height: 32),
          _buildWarningBox(),
        ],
      ),
    );
  }

  Widget _buildAgeLineChart() {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        size: const Size(double.infinity, 180),
        painter: _LineChartPainter(accentColor: _accentColor),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Khả năng có thai giảm rõ rệt theo từng năm sau tuổi 35. Hãy tham khảo ý kiến bác sĩ càng sớm càng tốt.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.red.shade800,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Card 4: Yếu tố ảnh hưởng
  // ============================================================
  Widget _buildInfluencingFactorsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yếu tố ảnh hưởng',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Các yếu tố chính ảnh hưởng đến kết quả',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          _buildFactorItem(
            icon: Icons.cake_outlined,
            label: _userGender == 'Nam' ? 'Tuổi của bạn' : 'Tuổi của bạn',
            level: 'Ảnh hưởng Cao',
            color: const Color(0xFFE53935),
            fraction: 0.9,
          ),
          const SizedBox(height: 20),
          _buildFactorItem(
            icon: _userGender == 'Nam' ? Icons.biotech_rounded : Icons.science_outlined,
            label: _userGender == 'Nam' ? 'Chất lượng tinh trùng' : 'Chỉ số AMH',
            level: _userGender == 'Nam' ? 'Bình thường' : 'Ảnh hưởng Trung bình',
            color: _userGender == 'Nam' ? const Color(0xFF43A047) : const Color(0xFFFB8C00),
            fraction: _userGender == 'Nam' ? 0.4 : 0.6,
          ),
          const SizedBox(height: 20),
          _buildFactorItem(
            icon: Icons.timer_outlined,
            label: 'Thời gian mong con',
            level: 'Ảnh hưởng Cao',
            color: const Color(0xFFE53935),
            fraction: 0.85,
          ),
          const SizedBox(height: 20),
          _buildFactorItem(
            icon: Icons.monitor_weight_outlined,
            label: 'Chỉ số BMI',
            level: 'Bình thường',
            color: const Color(0xFF43A047),
            fraction: 0.35,
          ),
        ],
      ),
    );
  }

  Widget _buildFactorItem({
    required IconData icon,
    required String label,
    required String level,
    required Color color,
    required double fraction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 6, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-2, -2)),
                ],
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 4, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                ],
              ),
              child: Text(
                level,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 2)),
              BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * fraction,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Card 5: Gợi ý cá nhân hóa
  // ============================================================
  Widget _buildPersonalizedSuggestionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gợi ý cá nhân hóa',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildSuggestionItem(
            _userGender == 'Nam' ? Icons.smoke_free_outlined : Icons.biotech_outlined,
            _userGender == 'Nam' 
                ? 'Nên hạn chế hút thuốc và rượu bia để cải thiện chất lượng tinh binh.' 
                : 'Nên làm xét nghiệm AMH để đánh giá dự trữ buồng trứng chính xác hơn.',
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            Icons.medical_services_outlined,
            _userGender == 'Nam'
                ? 'Đặt lịch khám nam khoa để kiểm tra sức khỏe sinh sản tổng quát.'
                : 'Cân nhắc tư vấn với bác sĩ chuyên khoa về các phương pháp hỗ trợ sinh sản.',
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            _userGender == 'Nam' ? Icons.fitness_center_outlined : Icons.restaurant_outlined,
            _userGender == 'Nam'
                ? 'Duy trì chế độ ăn giàu kẽm và tập thể dục đều đặn 30p mỗi ngày.'
                : 'Bổ sung axit folic và vitamin tổng hợp hằng ngày để tăng cơ hội thụ thai.',
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            Icons.spa_outlined,
            'Giảm bớt áp lực công việc, ngủ đủ giấc để cân bằng nội tiết tố.',
          ),
        ],
      ),
    );
  }

  Widget _buildActionRoadmapCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lộ trình hành động',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildRoadmapItem(1, 'Giai đoạn chuẩn bị', _userGender == 'Nam' ? 'Tăng cường sức khỏe, bỏ thói quen xấu.' : 'Bổ sung vitamin, theo dõi chu kỳ.'),
          _buildRoadmapVerticalLine(),
          _buildRoadmapItem(2, 'Kiểm tra lâm sàng', _userGender == 'Nam' ? 'Xét nghiệm tinh dịch đồ & nội tiết.' : 'Siêu âm đầu dò & xét nghiệm AMH.'),
          _buildRoadmapVerticalLine(),
          _buildRoadmapItem(3, 'Tư vấn phác đồ', 'Thảo luận kết quả cùng chuyên gia sinh sản.'),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(int step, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 6, offset: const Offset(2, 2)),
              BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-2, -2)),
            ],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: GoogleFonts.plusJakartaSans(color: _accentColor, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryColor)),
              const SizedBox(height: 2),
              Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoadmapVerticalLine() {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 4, bottom: 4),
      width: 2,
      height: 20,
      color: _accentColor.withOpacity(0.3),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _accentColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.blueGrey.shade800,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Footer Button
  // ============================================================
  Widget _buildFooterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 12, offset: const Offset(6, 6)),
            BoxShadow(color: _lightShadow, blurRadius: 12, offset: const Offset(-6, -6)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Center(
              child: Text(
                'Quay lại trang chủ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Data classes for chart
// ============================================================
class _BarData {
  final String label;
  final double value;
  final Color color;
  const _BarData(this.label, this.value, this.color);
}

class _LegendItem {
  final String label;
  final Color color;
  const _LegendItem(this.label, this.color);
}

// ============================================================
// CustomPainter for Age Line Chart
// ============================================================
class _LineChartPainter extends CustomPainter {
  final Color accentColor;

  _LineChartPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Age labels at bottom
    final ages = ['20', '25', '30', '35', '40', '45'];
    for (int i = 0; i < ages.length; i++) {
      final x = size.width * i / (ages.length - 1);
      final textSpan = TextSpan(
        text: ages[i],
        style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 18),
      );
    }

    // Chart area (leave bottom 24px for labels)
    final chartHeight = size.height - 28;

    // Data points (success rate by age): declining curve
    final points = [
      Offset(0, chartHeight * 0.15),
      Offset(size.width * 0.2, chartHeight * 0.2),
      Offset(size.width * 0.4, chartHeight * 0.3),
      Offset(size.width * 0.6, chartHeight * 0.5),
      Offset(size.width * 0.8, chartHeight * 0.72),
      Offset(size.width, chartHeight * 0.88),
    ];

    // Gradient fill under the curve
    final fillPath = Path()..moveTo(points.first.dx, chartHeight);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withOpacity(0.4),
          accentColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // Draw the line
    paint.color = accentColor;
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    // Using smooth curve through points
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 6, dotBorderPaint);
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Highlight the "danger zone" after 35 (index 3)
    final dangerPaint = Paint()
      ..color = const Color(0xFFE53935).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final dangerRect = Rect.fromLTRB(
      size.width * 0.6,
      0,
      size.width,
      chartHeight,
    );
    canvas.drawRect(dangerRect, dangerPaint);

    // "35 tuổi" label
    final labelSpan = TextSpan(
      text: '35 tuổi ↓',
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFE53935),
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(size.width * 0.6 + 6, 6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
