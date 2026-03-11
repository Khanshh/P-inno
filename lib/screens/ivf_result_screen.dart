import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'natural_result_screen.dart';

class IVFResultScreen extends StatefulWidget {
  final Map<String, dynamic>? resultData;
  const IVFResultScreen({super.key, this.resultData});

  @override
  State<IVFResultScreen> createState() => _IVFResultScreenState();
}

class _IVFResultScreenState extends State<IVFResultScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  // Premium Theme Colors (Modern Health-Tech)
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Hopeful gradient start
  
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
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double probability = widget.resultData?['probability_percent']?.toDouble() ?? 58.0;
    final String interpretation = widget.resultData?['interpretation'] ?? 'Bạn có cơ hội 58% thành công khi sử dụng phương pháp IVF.';

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
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      _buildChartCard(probability),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              side: BorderSide(color: _accentColor.withOpacity(0.3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Quay lại trang chủ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInterpretationCard(interpretation),
                      _buildEfficiencyCompareCard(probability),
                      _buildProcedureCard(),
                      _buildProsConsCard(),
                      _buildCompareCard(context),
                      _buildWarningBox(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                              shadowColor: _primaryColor.withOpacity(0.4),
                            ),
                            child: Text(
                              'Quay lại trang chủ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 150 + (30 * _backgroundController.value),
              right: -100 + (25 * _backgroundController.value),
              child: _buildOrb(420, const Color(0xFFD1F1D1).withOpacity(0.4)),
            ),
            Positioned(
              bottom: 150 + (40 * _backgroundController.value),
              left: -120 + (20 * _backgroundController.value),
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
        gradient: LinearGradient(
          colors: [_accentColor, const Color(0xFF4A9EAD)], // Hopeful gradient
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
            onTap: () => Navigator.pop(context),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kết quả sinh sản IVF',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Thụ tinh trong ống nghiệm (IVF)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInterpretationCard(String interpretation) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Phân tích của AI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: interpretation,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: Colors.blueGrey.shade800,
                height: 1.7,
                fontWeight: FontWeight.w500,
              ),
              h1: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                height: 1.4,
              ),
              h2: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                height: 1.4,
              ),
              h3: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                height: 1.4,
              ),
              listBullet: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: Colors.blueGrey.shade800,
              ),
              strong: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(double probability) {
    int percentage = probability.round();
    return _buildCard(
      child: Column(
        children: [
          Text(
            'Khả năng trong mỗi chu kỳ\n(chuyển phôi)',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _accentColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  value: probability / 100.0,
                  strokeWidth: 16,
                  backgroundColor: _bgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                  strokeAlign: CircularProgressIndicator.strokeAlignInside,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percentage%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: _primaryColor,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'Thành công',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildLegendItem(_accentColor, 'Thành công ($percentage%)'),
              _buildLegendItem(_bgColor, 'Chưa thành công (${100 - percentage}%)', hasBorder: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, {bool hasBorder = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: hasBorder ? Border.all(color: Colors.blueGrey.shade200) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyCompareCard(double probability) {
    int percentage = probability.round();
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'So sánh hiệu quả',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: _darkShadow.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tự nhiên\n(Dự tính trung bình)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, 
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '42%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueGrey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accentColor.withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: _accentColor.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'IVF\n(Trường hợp của bạn)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _primaryColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$percentage%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
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

  Widget _buildProcedureCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Thực hiện IVF',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProcedureStep(1, 'Kích trứng', '10-14 ngày', true),
          _buildProcedureStep(2, 'Thụ tinh trong lab', '3-5 ngày', true),
          _buildProcedureStep(3, 'Chuyển phôi', '1 ngày', true),
          _buildProcedureStep(4, 'Xét nghiệm chuẩn đoán', '2 tuần', false),
        ],
      ),
    );
  }

  Widget _buildProcedureStep(int step, String title, String time, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _accentColor),
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 30,
                color: const Color(0xFFE2E8F0),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    time,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProsConsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_information_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Ưu nhược điểm',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Ưu điểm',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 12),
          _buildChecklistItem('Tỉ lệ thành công cao nhất trong các phương pháp', true),
          const SizedBox(height: 10),
          _buildChecklistItem('Hỗ trợ sàng lọc phôi (PGT)', true),
          const SizedBox(height: 10),
          _buildChecklistItem('Kiểm soát tốt chất lượng phôi', true),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFE2E8F0), thickness: 1.5),
          ),
          
          Text(
            'Cần lưu ý',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFF9800),
            ),
          ),
          const SizedBox(height: 12),
          _buildChecklistItem('Chi phí thực hiện cao', false),
          const SizedBox(height: 10),
          _buildChecklistItem('Cần thời gian theo dõi dài', false),
          const SizedBox(height: 10),
          _buildChecklistItem('Có thể gây căng thẳng (stress)', false),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isPro) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPro)
          const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 20)
        else
          const Icon(Icons.info_rounded, color: Color(0xFFFF9800), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompareCard(BuildContext context) {
    return _buildCard(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.compare_arrows_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'So sánh phương pháp',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NaturalResultScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _primaryColor,
                elevation: 4,
                shadowColor: _darkShadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: _accentColor.withOpacity(0.3)),
                ),
              ),
              child: Text(
                'Xem kết quả Tự nhiên',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE082).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF57F17), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Kết quả này được tính toán dựa trên dữ liệu bạn cung cấp và số liệu thống kê chung. Hãy thăm khám bác sĩ để được tư vấn chính xác nhất.',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFB45F06),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
