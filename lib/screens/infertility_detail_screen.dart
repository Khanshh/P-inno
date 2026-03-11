import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hospital_list_screen.dart';
import '../models/discover_model.dart';

class InfertilityDetailScreen extends StatefulWidget {
  const InfertilityDetailScreen({super.key});

  @override
  State<InfertilityDetailScreen> createState() => _InfertilityDetailScreenState();
}

class _InfertilityDetailScreenState extends State<InfertilityDetailScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
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
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
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
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  children: [
                    // Section 1: Hiếm muộn là gì?
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(Icons.favorite_rounded, 'Hiếm muộn là gì?'),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: Colors.blueGrey.shade800,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Hiếm muộn ',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800,
                                    color: _primaryColor,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      'là tình trạng một cặp vợ chồng không thể mang thai sau 12 tháng quan hệ tình dục thường xuyên (2-3 lần/ tuần) mà không sử dụng bất kỳ biện pháp tránh thai nào.',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildHighlightBox(
                            'Đối với phụ nữ trên 35 tuổi, thời gian này được rút ngắn xuống còn 6 tháng.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section 2: Nguyên nhân hiếm muộn
                    _buildSectionTitle(Icons.warning_amber_rounded, 'Nguyên nhân hiếm muộn', isTitleOnly: true),
                    const SizedBox(height: 16),
                    _buildCauseCard(
                      title: 'Nguyên nhân từ phụ nữ',
                      percentage: '40%',
                      colors: [const Color(0xFFE3F2FD), const Color(0xFF1976D2)],
                      causes: [
                        'Rối loạn phóng noãn',
                        'Tắc nghẽn vòi trứng',
                        'Lạc nội mạc tử cung',
                        'Rối loạn tử cung',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCauseCard(
                      title: 'Nguyên nhân từ nam giới',
                      percentage: '40%',
                      colors: [const Color(0xFFE8F5E9), const Color(0xFF388E3C)],
                      causes: [
                        'Số lượng tinh trùng thấp',
                        'Chất lượng tinh trùng kém',
                        'Rối loạn cương dương',
                        'Tắc nghẽn ống dẫn tinh',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCauseCard(
                      title: 'Nguyên nhân không rõ',
                      percentage: '20%',
                      colors: [const Color(0xFFFFF3E0), const Color(0xFFF57C00)],
                      causes: [
                        'Không xác định được nguyên nhân cụ thể',
                        'Yếu tố miễn dịch',
                        'Yếu tố tâm lý, căng thẳng',
                        'Các yếu tố môi trường',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildWarningBox(
                      'Trong một số trường hợp, hiếm muộn có thể do sự kết hợp nguyên nhân từ cả vợ và chồng. Việc thăm khám kỹ lưỡng là bước quan trọng đầu tiên.',
                    ),
                    const SizedBox(height: 32),

                    // Section 3: Phương pháp điều trị
                    _buildSectionTitle(Icons.medical_services_outlined, 'Phương pháp điều trị', isTitleOnly: true),
                    const SizedBox(height: 16),
                    _buildTreatmentMethodCard(
                      icon: Icons.medication_rounded,
                      title: 'Điều trị thuốc',
                      subtitle: 'Sử dụng thuốc kích thích rụng trứng hoặc điều chỉnh nội tiết',
                    ),
                    const SizedBox(height: 16),
                    _buildTreatmentMethodCard(
                      icon: Icons.healing_rounded,
                      title: 'Phẫu thuật',
                      subtitle: 'Can thiệp phẫu thuật khắc phục các bất thường cấu trúc',
                    ),
                    const SizedBox(height: 16),
                    _buildTreatmentMethodCard(
                      icon: Icons.biotech_rounded,
                      title: 'Hỗ trợ sinh sản (ART)',
                      subtitle: 'IVF, IUI, ICSI và các kỹ thuật sinh sản hiện đại',
                    ),
                    const SizedBox(height: 16),
                    _buildTreatmentMethodCard(
                      icon: Icons.self_improvement_rounded,
                      title: 'Thay đổi lối sống',
                      subtitle: 'Chế độ ăn uống, tập luyện và giảm căng thẳng',
                    ),
                    const SizedBox(height: 32),

                    // Section 4: Lời khuyên
                    _buildFooterCard(),
                    const SizedBox(height: 24),
                    _buildActionButton(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 150 + (30 * _backgroundController.value),
              right: -120 + (40 * _backgroundController.value),
              child: _buildOrb(420, const Color(0xFFD1F1D1).withOpacity(0.4)),
            ),
            Positioned(
              bottom: 50 + (20 * _backgroundController.value),
              left: -100 + (30 * _backgroundController.value),
              child: _buildOrb(480, const Color(0xFFD1E2F1).withOpacity(0.5)),
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

  Widget _buildGlassHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
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
        bottom: 30,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Tìm hiểu về hiếm muộn',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {bool isTitleOnly = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _accentColor, size: 22),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightBox(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF1976D2), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF0D47A1),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseCard({
    required String title,
    required String percentage,
    required List<Color> colors,
    required List<String> causes,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colors[0],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  percentage,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors[1],
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...causes.map((cause) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: colors[1].withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        cause,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWarningBox(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Color(0xFFF57C00), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFE65100),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _accentColor, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.blueGrey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 24),
        ],
      ),
    );
  }

  Widget _buildFooterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, const Color(0xFF2D6A74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFE2F1AF), size: 32),
          const SizedBox(height: 16),
          Text(
            'Lời khuyên từ chuyên gia',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Đừng quá lo lắng, y học hiện đại có nhiều giải pháp hỗ trợ. Hãy đi khám sớm để được tư vấn chính xác nhất.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HospitalListScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.location_on_rounded, size: 24),
        label: Text(
          'THAM KHẢO PHÒNG KHÁM',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
