import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ivf_result_screen.dart';
import '../services/api_service.dart';

class NaturalResultScreen extends StatefulWidget {
  final Map<String, dynamic>? resultData;
  final Map<String, dynamic>? femaleData;
  final Map<String, dynamic>? maleData;

  const NaturalResultScreen({super.key, this.resultData, this.femaleData, this.maleData});

  @override
  State<NaturalResultScreen> createState() => _NaturalResultScreenState();
}

class _NaturalResultScreenState extends State<NaturalResultScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  // Premium Theme Colors (Modern Health-Tech)
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Hopeful gradient start
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF); 
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); 
  final ApiService _apiService = ApiService();

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
    final double probability = widget.resultData?['probability_percent']?.toDouble() ?? 42.0;
    final String interpretation = widget.resultData?['interpretation'] ?? 'Dựa trên thống kê tổng quát, bạn có 42% cơ hội thụ thai tự nhiên.';
    final String probRange = widget.resultData?['probability_range'] ?? '';
    final List<dynamic> timelineData = widget.resultData?['timeline_data'] ?? [];
    final int breakPoint = widget.resultData?['break_point'] ?? 12;

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
                      _buildChartCard(probability, probRange),
                      const SizedBox(height: 8),
                      if (timelineData.isNotEmpty)
                        _buildTimelineCard(timelineData, breakPoint),
                      const SizedBox(height: 16),
                      _buildInterpretationCard(interpretation),
                      _buildFactorsCard(widget.resultData?['factors_summary']),
                      _buildSuggestionsCard(widget.resultData?['recommendations']),
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
                  'Kết quả sinh sản tự nhiên',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dự đoán khả năng thành công',
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

  Widget _buildChartCard(double probability, String probRange) {
    int percentage = probability.round();
    return _buildCard(
      child: Column(
        children: [
          Text(
            'Khả năng trong 1 năm tới',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
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
          if (probRange.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _accentColor.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_rounded, color: _accentColor, size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Khoảng tin cậy',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.blueGrey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        probRange,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
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

  Widget _buildTimelineCard(List<dynamic> timelineData, int breakPoint) {
    List<FlSpot> spots = timelineData.map((d) => FlSpot(
      (d['month'] as num).toDouble(),
      (d['cumulative_probability'] as num).toDouble(),
    )).toList();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Lộ trình 24 tháng',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.blueGrey.shade100,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 6,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'T${value.toInt()}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.blueGrey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.blueGrey.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
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
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(colors: [_accentColor, const Color(0xFF4A9EAD)]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [_accentColor.withOpacity(0.3), _accentColor.withOpacity(0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: breakPoint.toDouble(),
                      color: Colors.redAccent.withOpacity(0.5),
                      strokeWidth: 2,
                      dashArray: [5, 5],
                      label: VerticalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.redAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        labelResolver: (_) => 'Điểm gãy',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Traffic Light Legend
          _buildZoneRow(Colors.green, '🟢 Vùng thoải mái', 'Hãy cứ thả tự nhiên thoải mái.'),
          const SizedBox(height: 10),
          _buildZoneRow(Colors.orange, '🟡 Vùng lưu ý', 'Tỷ lệ bắt đầu chững lại, tìm hiểu kiến thức.'),
          const SizedBox(height: 10),
          _buildZoneRow(Colors.red, '🔴 Vùng hành động', 'Thời điểm vàng để đặt lịch khám.'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sau tháng $breakPoint, khả năng bắt đầu bão hòa. Hãy cân nhắc tư vấn bác sĩ.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneRow(Color color, String title, String desc) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildFactorsCard(Map<String, dynamic>? factorsSummary) {
    if (factorsSummary == null || factorsSummary.isEmpty) return const SizedBox.shrink();

    // Map impact -> display label & color
    String _impactLabel(String impact) {
      switch (impact) {
        case 'positive': return 'Thuận lợi';
        case 'negative': return 'Bất lợi';
        default: return 'Bình thường';
      }
    }
    Color _impactColor(String impact) {
      switch (impact) {
        case 'positive': return const Color(0xFF4CAF50);
        case 'negative': return const Color(0xFFF44336);
        default: return const Color(0xFFFF9800);
      }
    }

    final entries = factorsSummary.entries.toList();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Yếu tố ảnh hưởng',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...entries.asMap().entries.map((entry) {
            final idx = entry.key;
            final factor = entry.value.value;
            if (factor is! Map) return const SizedBox.shrink();
            final label = factor['label'] ?? entry.value.key;
            final impact = factor['impact'] ?? 'neutral';
            final value = factor['value'];
            final source = factor['source'];

            String displayValue = _impactLabel(impact);
            if (value != null && value is num) {
              displayValue = '$value';
              if (factor['unit'] != null) displayValue += ' ${factor['unit']}';
            } else if (value is bool) {
              displayValue = value ? 'Có' : 'Không';
            }
            if (source == 'estimated') {
              displayValue += ' (ước tính)';
            }

            return Column(
              children: [
                _buildFactorRow(label.toString(), displayValue, _impactColor(impact)),
                if (idx < entries.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: Color(0xFFE2E8F0), thickness: 1.5),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFactorRow(String title, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15, 
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsCard(List<dynamic>? recommendations) {
    final List<String> recs = (recommendations ?? []).map((e) => e.toString()).toList();
    if (recs.isEmpty) {
      recs.addAll([
        'Duy trì lối sống lành mạnh, tập thể dục đều đặn.',
        'Theo dõi rụng trứng chính xác hơn.',
        'Kiểm tra định kỳ chất lượng sinh sản.',
      ]);
    }

    final icons = [
      Icons.favorite_rounded,
      Icons.calendar_month_rounded,
      Icons.fitness_center_rounded,
      Icons.health_and_safety_rounded,
      Icons.local_hospital_rounded,
      Icons.science_rounded,
      Icons.monitor_heart_rounded,
      Icons.medication_rounded,
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Gợi ý cải thiện',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...recs.asMap().entries.map((entry) {
            final icon = icons[entry.key % icons.length];
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key < recs.length - 1 ? 16 : 0),
              child: _buildSuggestionItem(icon, entry.value),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade700,
                height: 1.5,
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
              onPressed: () async {
                if (widget.femaleData == null || widget.maleData == null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IVFResultScreen()));
                  return;
                }
                
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: _bgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_accentColor)),
                            const SizedBox(height: 24),
                            Text('Đang phân tích dữ liệu IVF...', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryColor)),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  final result = await _apiService.runSimulation('sart_ivf', widget.femaleData!, widget.maleData!);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => IVFResultScreen(resultData: result, femaleData: widget.femaleData, maleData: widget.maleData)),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IVFResultScreen()));
                }
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
                'Xem kết quả IVF',
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
