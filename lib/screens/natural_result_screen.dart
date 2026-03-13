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
  final ScrollController _mainScrollController = ScrollController();

  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF); 
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); 
  final ApiService _apiService = ApiService();

  late Map<String, dynamic>? _simResult;
  late Map<String, dynamic> _simFemaleData;
  late Map<String, dynamic> _simMaleData;
  bool _isSimulating = false;
  bool _isWhatIfMode = false;

  @override
  void initState() {
    super.initState();
    _simResult = widget.resultData;
    _simFemaleData = Map<String, dynamic>.from(widget.femaleData ?? {});
    _simMaleData = Map<String, dynamic>.from(widget.maleData ?? {});
    
    // Ensure BMI and Age are initialized within valid ranges
    _simFemaleData['bmi'] = _clamp((_simFemaleData['bmi'] ?? _calculateBMI(_simFemaleData)).toDouble(), 15.0, 40.0);
    _simFemaleData['age'] = _clamp((_simFemaleData['age'] ?? 30.0).toDouble(), 18.0, 45.0);
    _simMaleData['bmi'] = _clamp((_simMaleData['bmi'] ?? 24.0).toDouble(), 15.0, 40.0);

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  double _clamp(double val, double min, double max) {
    if (val < min) return min;
    if (val > max) return max;
    return val;
  }

  double _calculateBMI(Map<String, dynamic> data) {
    final h = data['height'];
    final w = data['weight'];
    if (h != null && w != null) {
      final double hd = (h is num) ? h.toDouble() : (double.tryParse(h.toString()) ?? 0);
      final double wd = (w is num) ? w.toDouble() : (double.tryParse(w.toString()) ?? 0);
      if (hd > 0) return wd / ((hd / 100) * (hd / 100));
    }
    return 22.0;
  }

  bool _parseBool(dynamic val) {
    if (val == null) return false;
    if (val is bool) return val;
    final s = val.toString().toLowerCase();
    return s == 'có' || s == 'yes' || s == 'true';
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double probability = _simResult?['probability_percent']?.toDouble() ?? 42.0;
    final String interpretation = _simResult?['interpretation'] ?? 'Dựa trên thống kê tổng quát và thông tin bạn cung cấp, chúng tôi đã chuẩn bị lộ trình phù hợp cho bạn.';
    final int breakPoint = _simResult?['break_point'] ?? 12;

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
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      if (_simResult?['patient_group'] != null)
                        _buildPatientGroupCard(_simResult?['patient_group']),
                      const SizedBox(height: 16),
                      _buildInterpretationCard(interpretation),
                      _buildWhatIfLab(),
                      // Roadmap (Timeline) now always uses original data
                      _buildActionPlanTimeline(widget.resultData?['break_point'] ?? 12, originalData: widget.resultData),
                      _buildFactorsCard(_simResult?['factors_summary']),
                      _buildSuggestionsCard(_simResult?['recommendations']),
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
          if (_isSimulating)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
              ),
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

  Widget _buildGlassHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryColor.withOpacity(0.85)],
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Phân tích cá nhân hóa',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.5),
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
      child: child,
    );
  }

  Widget _buildPatientGroupCard(Map<String, dynamic> group) {
    final String name = group['name'] ?? 'Chưa xác định';
    final String colorHex = group['color'] ?? '#1D4E56';
    final Color groupColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    final String iconName = group['icon'] ?? 'stars_rounded';
    final String desc = group['description'] ?? '';

    return _buildCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: groupColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIconData(iconName), color: groupColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nhóm bệnh nhân',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 1,
                      ),
                    ),
                    if (_isWhatIfMode)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _accentColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'KỊCH BẢN GIẢ LẬP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: groupColor,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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

  Widget _buildInterpretationCard(String text) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: _accentColor, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Phân tích từ AI Assistant',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
              if (_isWhatIfMode)
                const Icon(Icons.biotech_rounded, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: Colors.blueGrey.shade800,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPlanTimeline(int breakPoint, {Map<String, dynamic>? originalData}) {
    // Always fallback to widget.resultData to ensure roadmap is based on survey
    final List<dynamic> timelineData = (originalData ?? widget.resultData)?['timeline_data'] ?? [];
    if (timelineData.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.map_outlined, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Lộ trình tối ưu hóa',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimelineStep(
            'Tháng 1 - Tháng ${breakPoint ~/ 2}',
            'Giai đoạn Vàng: Tự nhiên & Lối sống',
            'Tập trung vào dinh dưỡng, bổ sung vitamin cho cả hai vợ chồng và theo dõi chu kỳ rụng trứng.',
            Icons.wb_sunny_rounded,
            Colors.green,
            true,
          ),
          _buildTimelineStep(
            'Tháng ${breakPoint ~/ 2 + 1} - Tháng $breakPoint',
            'Giai đoạn Lưu ý: Theo dõi chuyên sâu',
            'Nếu chưa có tin vui, hai bạn nên thực hiện các kiểm tra cơ bản (AMH, tinh dịch đồ) để hiểu rõ hơn.',
            Icons.visibility_rounded,
            Colors.orange,
            true,
          ),
          _buildTimelineStep(
            'Sau tháng $breakPoint',
            'Giai đoạn Hành động: Tư vấn chuyên gia',
            'Đã đến lúc cần phác đồ chuyên biệt từ bác sĩ để rút ngắn hành trình đón con yêu.',
            Icons.medical_services_rounded,
            Colors.redAccent,
            false,
          ),
        ],
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

  Widget _buildFactorsCard(dynamic factors) {
    if (factors == null) return const SizedBox.shrink();

    List<Widget> factorItems = [];
    if (factors is Map) {
      factors.forEach((key, f) {
        if (f is Map) {
          factorItems.add(_buildFactorItem(
            f['label'] ?? key.toString(),
            f['value']?.toString() ?? '',
            f['impact'] ?? 'neutral',
          ));
        }
      });
    } else if (factors is List) {
      for (var f in factors) {
        factorItems.add(_buildFactorItem(
          f['factor'] ?? '',
          f['impact'] ?? '',
          f['status'] ?? 'neutral',
        ));
      }
    }

    if (factorItems.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Các yếu tố ảnh hưởng',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...factorItems,
        ],
      ),
    );
  }

  Widget _buildFactorItem(String title, String impact, String status) {
    Color statusColor;
    IconData icon;

    switch (status) {
      case 'positive':
        statusColor = Colors.green;
        icon = Icons.check_circle_rounded;
        break;
      case 'negative':
        statusColor = Colors.redAccent;
        icon = Icons.info_rounded;
        break;
      default:
        statusColor = Colors.orange;
        icon = Icons.help_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: statusColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _primaryColor,
                  ),
                ),
                Text(
                  impact,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsCard(List<dynamic>? recommendations) {
    if (recommendations == null || recommendations.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Khuyến nghị từ hệ thống',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((r) => _buildSuggestionItem(r.toString())),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•", style: TextStyle(color: _accentColor, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.blueGrey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareCard(BuildContext context) {
    return _buildCard(
      child: Row(
        children: [
          Icon(Icons.compare_arrows_rounded, color: _accentColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tìm hiểu về IVF?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Khám phá lộ trình hỗ trợ sinh sản chuyên sâu hơn.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.blueGrey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IVFResultScreen())),
            icon: Icon(Icons.arrow_forward_ios_rounded, color: _primaryColor, size: 18),
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

  Widget _buildWhatIfLab() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.biotech_rounded, color: _accentColor, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Phòng giả lập AI',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
              if (_isWhatIfMode)
                TextButton.icon(
                  onPressed: _resetToOriginal,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Thực tế'),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Thay đổi các yếu tố để xem AI tối ưu hóa lộ trình của hai bạn như thế nào.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.blueGrey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildLabSlider(
            'Tuổi của Vợ',
            _clamp((_simFemaleData['age'] is num) ? (_simFemaleData['age'] as num).toDouble() : 30.0, 18.0, 45.0),
            18.0,
            45.0,
            (val) {
              setState(() {
                _simFemaleData['age'] = val;
                _isWhatIfMode = true;
              });
            },
            '${_clamp(((_simFemaleData['age'] ?? 30) as num).toDouble(), 18.0, 45.0).toInt()} tuổi'
          ),

          _buildLabSlider(
            'BMI của Vợ (Cân nặng/Chiều cao)',
            _clamp((_simFemaleData['bmi'] is num) ? (_simFemaleData['bmi'] as num).toDouble() : 22.0, 15.0, 40.0),
            15.0,
            40.0,
            (val) {
              setState(() {
                _simFemaleData['bmi'] = val;
                _isWhatIfMode = true;
              });
            },
            '${_clamp(((_simFemaleData['bmi'] ?? 22.0) as num).toDouble(), 15.0, 40.0).toStringAsFixed(1)}'
          ),

          _buildLabSlider(
            'BMI của Chồng',
            _clamp((_simMaleData['bmi'] is num) ? (_simMaleData['bmi'] as num).toDouble() : 24.0, 15.0, 40.0),
            15.0,
            40.0,
            (val) {
              setState(() {
                _simMaleData['bmi'] = val;
                _isWhatIfMode = true;
              });
            },
            '${_clamp(((_simMaleData['bmi'] ?? 24.0) as num).toDouble(), 15.0, 40.0).toStringAsFixed(1)}'
          ),
          
          _buildLabToggle(
            'Chồng không hút thuốc lá',
            !_parseBool(_simMaleData['smoking']),
            (val) {
              setState(() {
                _simMaleData['smoking'] = val ? 'Không' : 'Có';
                _isWhatIfMode = true;
              });
            },
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isSimulating ? null : _runWhatIfSimulation,
              icon: _isSimulating 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.play_circle_fill_rounded, color: Colors.white),
              label: Text(
                _isSimulating ? 'ĐANG TÍNH TOÁN...' : 'CHẠY GIẢ LẬP KỊCH BẢN',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabSlider(String label, double value, double min, double max, Function(double) onChanged, String displayVal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(displayVal, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: _primaryColor, fontSize: 12)),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: _accentColor,
          inactiveColor: _accentColor.withOpacity(0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLabToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
        Switch(
          value: value,
          activeColor: _accentColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _runWhatIfSimulation() async {
    setState(() => _isSimulating = true);
    try {
      final newResult = await _apiService.runSimulation(
        'hunault',
        _simFemaleData,
        _simMaleData,
      );
      setState(() {
        _simResult = newResult;
        _isSimulating = false;
      });
      // Scroll to top to see results
      _mainScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuart,
      );
    } catch (e) {
      setState(() => _isSimulating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể chạy giả lập: $e')),
        );
      }
    }
  }

  void _resetToOriginal() {
    setState(() {
      _simResult = widget.resultData;
      _simFemaleData = Map<String, dynamic>.from(widget.femaleData ?? {});
      _simMaleData = Map<String, dynamic>.from(widget.maleData ?? {});
      _isWhatIfMode = false;
    });
    _mainScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
    );
  }
}
