import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key});

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);

  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kết quả đánh giá',
          style: GoogleFonts.plusJakartaSans(
            color: _primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Score Circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _bgColor,
                boxShadow: [
                  BoxShadow(color: _darkShadow.withOpacity(0.6), blurRadius: 16, offset: const Offset(8, 8)),
                  BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(4, 6)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '72',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'điểm / 100',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Sức khỏe sinh sản: Khá tốt',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Dựa trên các thông tin bạn cung cấp, sức khỏe sinh sản của bạn ở mức khá. Hãy xem chi tiết bên dưới để biết thêm chi tiết.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Risk Factors
            _buildResultCard(
              icon: Icons.favorite_outline_rounded,
              title: 'Chu kỳ & Sinh lý',
              status: 'Bình thường',
              statusColor: const Color(0xFF43A047),
              description: 'Chu kỳ kinh nguyệt của bạn khá đều đặn, không có dấu hiệu bất thường.',
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              icon: Icons.monitor_heart_outlined,
              title: 'Triệu chứng nghi ngờ',
              status: 'Cần theo dõi',
              statusColor: const Color(0xFFFB8C00),
              description: 'Một số triệu chứng cần được theo dõi thêm. Nên tham khảo ý kiến bác sĩ.',
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              icon: Icons.nights_stay_outlined,
              title: 'Lối sống',
              status: 'Cần cải thiện',
              statusColor: const Color(0xFFE53935),
              description: 'Chất lượng giấc ngủ và mức độ stress cần được cải thiện đáng kể.',
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              icon: Icons.history_rounded,
              title: 'Tiền sử',
              status: 'Bình thường',
              statusColor: const Color(0xFF43A047),
              description: 'Không phát hiện yếu tố tiền sử đáng lo ngại.',
            ),

            const SizedBox(height: 32),

            // Suggestion
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _accentColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 10, offset: const Offset(4, 4)),
                  BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-4, -4)),
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
                          color: _accentColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lightbulb_outline_rounded, color: _primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Gợi ý từ hệ thống',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBulletPoint('Nên đi khám sức khỏe sinh sản định kỳ 6 tháng/lần'),
                  const SizedBox(height: 8),
                  _buildBulletPoint('Cải thiện giấc ngủ và giảm stress'),
                  const SizedBox(height: 8),
                  _buildBulletPoint('Bổ sung axit folic nếu có kế hoạch mang thai'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Back button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: _accentColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: Colors.blueGrey.shade700,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 10, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-4, -4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 4, offset: const Offset(2, 2), blurStyle: BlurStyle.inner),
                          BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2), blurStyle: BlurStyle.inner),
                        ],
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
