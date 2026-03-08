import 'package:flutter/material.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  static const Color _primaryColor = Color(0xFF73C6D9);
  static const Color _primaryDark = Color(0xFF4A9BB0);
  static const Color _scaffoldBg = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mô phỏng 3 tháng',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  'i',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildProbabilityCard(),
            const SizedBox(height: 16),
            _buildBarChartCard(),
            const SizedBox(height: 16),
            _buildAgeInfluenceCard(),
            const SizedBox(height: 16),
            _buildInfluencingFactorsCard(),
            const SizedBox(height: 16),
            _buildPersonalizedSuggestionsCard(),
            const SizedBox(height: 16),
            _buildFooterButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Card 1: Xác suất ước tính
  // ============================================================
  Widget _buildProbabilityCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [_primaryColor, const Color(0xFF4A8FA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xác suất ước tính',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '48% - 55%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 46,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Khả năng có thai trong 3 tháng tới',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.white.withOpacity(0.95),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Độ tin cậy: Trung bình',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 14,
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

  // ============================================================
  // Card 2: So sánh phương pháp (Bar Chart Mock)
  // ============================================================
  Widget _buildBarChartCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'So sánh phương pháp',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhấn vào cột để xem chi tiết',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          _buildBarChart(),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final List<_BarData> bars = [
      _BarData('Tự nhiên', 0.25, const Color(0xFF2C5F7C)),
      _BarData('KTPN', 0.35, const Color(0xFFE88D3F)),
      _BarData('IUI', 0.48, _primaryColor),
      _BarData('IVF', 0.72, const Color(0xFF8B5CF6)),
      _BarData('ICSI', 0.65, const Color(0xFFEC4899)),
    ];

    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((bar) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${(bar.value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: bar.color,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 32,
                height: 130 * bar.value,
                decoration: BoxDecoration(
                  color: bar.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bar.label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
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
      _LegendItem('IUI', _primaryColor),
      _LegendItem('IVF', const Color(0xFF8B5CF6)),
      _LegendItem('ICSI', const Color(0xFFEC4899)),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ảnh hưởng theo tuổi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tỷ lệ thành công theo độ tuổi',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _buildAgeLineChart(),
          const SizedBox(height: 20),
          _buildWarningBox(),
        ],
      ),
    );
  }

  Widget _buildAgeLineChart() {
    return SizedBox(
      height: 160,
      child: CustomPaint(
        size: const Size(double.infinity, 160),
        painter: _LineChartPainter(),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Khả năng có thai giảm rõ rệt theo từng năm sau tuổi 35. Hãy tham khảo ý kiến bác sĩ càng sớm càng tốt.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade800,
                height: 1.5,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yếu tố ảnh hưởng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Các yếu tố chính ảnh hưởng đến kết quả',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _buildFactorItem(
            icon: Icons.cake_outlined,
            label: 'Tuổi',
            level: 'Ảnh hưởng Cao',
            color: const Color(0xFFE53935),
            fraction: 0.9,
          ),
          const SizedBox(height: 16),
          _buildFactorItem(
            icon: Icons.science_outlined,
            label: 'AMH',
            level: 'Ảnh hưởng Trung bình',
            color: const Color(0xFFFB8C00),
            fraction: 0.6,
          ),
          const SizedBox(height: 16),
          _buildFactorItem(
            icon: Icons.timer_outlined,
            label: 'Thời gian >12 tháng',
            level: 'Ảnh hưởng Cao',
            color: const Color(0xFFE53935),
            fraction: 0.85,
          ),
          const SizedBox(height: 16),
          _buildFactorItem(
            icon: Icons.monitor_weight_outlined,
            label: 'BMI',
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gợi ý cá nhân hóa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            Icons.biotech_outlined,
            'Nên làm xét nghiệm AMH để đánh giá dự trữ buồng trứng chính xác hơn.',
          ),
          const SizedBox(height: 10),
          _buildSuggestionItem(
            Icons.medical_services_outlined,
            'Cân nhắc tư vấn với bác sĩ chuyên khoa về các phương pháp hỗ trợ sinh sản.',
          ),
          const SizedBox(height: 10),
          _buildSuggestionItem(
            Icons.restaurant_outlined,
            'Bổ sung axit folic và vitamin tổng hợp hằng ngày để tăng cơ hội thụ thai.',
          ),
          const SizedBox(height: 10),
          _buildSuggestionItem(
            Icons.fitness_center_outlined,
            'Duy trì lối sống lành mạnh: tập thể dục nhẹ, ngủ đủ giấc, giảm stress.',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.blueGrey.shade800,
                height: 1.5,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Quay lại trang chủ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 0.8;

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
        style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 14),
      );
    }

    // Y-axis labels
    final yLabels = ['80%', '60%', '40%', '20%', '0%'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = size.height * i / 4;
      final textSpan = TextSpan(
        text: yLabels[i],
        style: TextStyle(color: Colors.grey.shade500, fontSize: 9),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      // Don't paint, just skip for simplicity to avoid overlap
    }

    // Chart area (leave bottom 20px for labels)
    final chartHeight = size.height - 22;

    // Data points (success rate by age): declining curve
    final points = [
      Offset(0, chartHeight * 0.15),                          // Age 20: ~80%
      Offset(size.width * 0.2, chartHeight * 0.2),            // Age 25: ~75%
      Offset(size.width * 0.4, chartHeight * 0.3),            // Age 30: ~60%
      Offset(size.width * 0.6, chartHeight * 0.5),            // Age 35: ~45%
      Offset(size.width * 0.8, chartHeight * 0.72),           // Age 40: ~25%
      Offset(size.width, chartHeight * 0.88),                  // Age 45: ~10%
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
          const Color(0xFF73C6D9).withOpacity(0.3),
          const Color(0xFF73C6D9).withOpacity(0.03),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // Draw the line
    paint.color = const Color(0xFF73C6D9);
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
      ..color = const Color(0xFF73C6D9)
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotBorderPaint);
      canvas.drawCircle(point, 3.5, dotPaint);
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
      style: TextStyle(
        color: const Color(0xFFE53935),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(size.width * 0.6 + 4, 4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
