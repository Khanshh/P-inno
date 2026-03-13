import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assessment_form_screen.dart';
import 'partner_assessment_form_screen.dart';

class SimulationIntroScreen extends StatefulWidget {
  const SimulationIntroScreen({super.key});

  @override
  State<SimulationIntroScreen> createState() => _SimulationIntroScreenState();
}

class _SimulationIntroScreenState extends State<SimulationIntroScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  String _selectedGender = 'Nữ';
  bool _isLoadingGender = true;

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
        _selectedGender = prefs.getString('gender') ?? 'Nữ';
        _isLoadingGender = false;
      });
    }
  }

  Future<void> _saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender);
    setState(() {
      _selectedGender = gender;
    });
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
                      _buildHeroCard(),
                      const SizedBox(height: 24),
                      _buildGenderSelectionCard(),
                      const SizedBox(height: 24),
                      _buildWarningCard(),
                      const SizedBox(height: 24),
                      _buildStepsCard(),
                      const SizedBox(height: 100), // Khoảng trống cho footer
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(context),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mô phỏng cá nhân',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Công cụ dự đoán sinh sản',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
          BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 8, offset: const Offset(4, 4)),
                BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
              ],
            ),
            child: Icon(Icons.monitor_heart_rounded, size: 48, color: _primaryColor),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Mô phỏng khả năng có thai',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: _primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Công cụ dự đoán dựa trên dữ liệu y khoa, giúp bạn hiểu rõ hơn về khả năng sinh sản và lựa chọn phương pháp phù hợp.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade700,
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelectionCard() {
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
            'Cá nhân hóa giới tính',
            style: GoogleFonts.plusJakartaSans(
              color: _primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chọn giới tính của bạn để bắt đầu khảo sát phù hợp.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  'Nam',
                  Icons.male_rounded,
                  _selectedGender == 'Nam',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption(
                  'Nữ',
                  Icons.female_rounded,
                  _selectedGender == 'Nữ',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => _saveGender(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(color: _accentColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                ]
              : [
                  BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
                  BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? _accentColor : Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? _primaryColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 12, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 12, offset: const Offset(-4, -4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.info_outline_rounded, color: Colors.orange.shade700, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Lưu ý quan trọng',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Kết quả chỉ mang tính chất tham khảo, dựa trên dữ liệu thống kê. Không thay thế cho tư vấn y tế chuyên nghiệp.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.brown.shade700,
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
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
            'Cách thức hoạt động',
            style: GoogleFonts.plusJakartaSans(
              color: _primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          _buildStepItem(
            1,
            'Hoàn thành khảo sát',
            _selectedGender == 'Nam'
                ? 'Nhập thông tin của bạn và sau đó là thông tin của bạn đời (Nữ).'
                : 'Nhập thông tin của bạn và sau đó là thông tin của bạn đời (Nam).',
          ),
          const SizedBox(height: 16),
          _buildStepItem(2, 'Hệ thống phân tích', 'Xử lý dữ liệu dựa trên mô hình thuật toán lâm sàng.'),
          const SizedBox(height: 16),
          _buildStepItem(3, 'Nhận kết quả', 'Xem dự đoán khả năng thành công cho các phương pháp.'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded, color: _primaryColor, size: 20),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    text: 'Thời gian hoàn thành: ',
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: '3-5 phút',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: _primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2)),
            ],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: _primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoadingGender ? null : () {
                if (_selectedGender == 'Nam') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PartnerAssessmentFormScreen(isPartner: false)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AssessmentFormScreen(isPartner: false)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
                shadowColor: _primaryColor.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bắt đầu khảo sát',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, color: Colors.grey.shade500, size: 16),
              const SizedBox(width: 6),
              Text(
                'Miễn phí & Bảo mật tuyệt đối',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
