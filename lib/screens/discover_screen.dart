import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'infertility_detail_screen.dart';
import 'ivf_detail_screen.dart';
import 'icsi_detail_screen.dart';
import 'iui_detail_screen.dart';
import 'discover_method_detail_screen.dart';
import 'ktpn_detail_screen.dart';
import '../services/api_service.dart';
import '../models/discover_model.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<DiscoverMethodModel> _methods = [];
  bool _isLoading = true;
  String? _error;

  late AnimationController _backgroundController;

  // Premium Theme Colors (Modern Health-Tech)
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Hopeful gradient start
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF); // Matches Onboarding
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); // Soft blue-grey shadow

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadMethods();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadMethods() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final methods = await _apiService.getDiscoverMethods();
      setState(() {
        _methods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: _primaryColor))
                    : RefreshIndicator(
                        onRefresh: _loadMethods,
                        color: _primaryColor,
                        backgroundColor: _bgColor,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHighlightCard(),
                              const SizedBox(height: 32),
                              _buildSectionTitle('Phương pháp hỗ trợ sinh sản'),
                              const SizedBox(height: 8),
                              _buildSectionSubtitle('Các giải pháp y học hiện đại giúp tăng tỷ lệ thụ thai'),
                              const SizedBox(height: 24),
                              _buildGridCards(),
                              const SizedBox(height: 40),
                            ],
                          ),
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
              top: 50 + (30 * _backgroundController.value),
              right: -100 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFE2F1AF).withOpacity(0.4)),
            ),
            Positioned(
              bottom: -150 + (40 * _backgroundController.value),
              left: -120 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD1F1F1).withOpacity(0.6)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tìm Hiểu',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Kiến thức về hiếm muộn và các phương pháp hỗ trợ sinh sản',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17, // +3
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfertilityDetailScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: _darkShadow, blurRadius: 12, offset: const Offset(6, 6)),
            BoxShadow(color: _lightShadow, blurRadius: 12, offset: const Offset(-6, -6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 4, offset: const Offset(2, 2)),
                  BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                ],
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: _primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                'Tìm hiểu về hiếm muộn',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21, // +3
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _primaryColor.withOpacity(0.5),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 21, // +3
        fontWeight: FontWeight.w800,
        color: _primaryColor,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 17, // +3
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGridCards() {
    if (_methods.isEmpty) {
      return Center(
        child: Text(
          'Không có phương pháp nào',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 24,
          children: _methods.map((method) => _buildMethodCard(method, itemWidth)).toList(),
        );
      },
    );
  }

  Widget _buildMethodCard(DiscoverMethodModel method, double width) {
    String displayTitle = method.title;
    if (displayTitle.contains('Kích thích')) {
      displayTitle = 'FSH';
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: _darkShadow, blurRadius: 10, offset: const Offset(5, 5)),
          BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-5, -5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _navigateToDetail(context, method),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _bgColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 2)),
                          BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                        ],
                      ),
                      child: Icon(
                        _getIconData(method.icon),
                        color: const Color(0xFF4A9EAD), // Slightly vibrant teal
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  method.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15, // +2
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 2)),
                      BoxShadow(color: _lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chi tiết',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: _primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, DiscoverMethodModel method) {
    final title = method.title;
    if (title == 'IVF') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const IVFDetailScreen()));
    } else if (title == 'ICSI') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ICSIDetailScreen()));
    } else if (title == 'IUI') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const IUIDetailScreen()));
    } else if (title.contains('Kích thích')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const KTPNDetailScreen()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscoverMethodDetailScreen(
            methodId: method.id,
            title: title,
          ),
        ),
      );
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'science_outlined':
        return Icons.science_outlined;
      case 'medical_services_outlined':
        return Icons.medical_services_outlined;
      case 'biotech_outlined':
        return Icons.biotech_outlined;
      case 'ac_unit_outlined':
        return Icons.ac_unit_outlined;
      case 'bubble_chart_outlined':
        return Icons.bubble_chart_outlined;
      case 'vaccines':
        return Icons.vaccines_outlined;
      case 'medication_liquid':
        return Icons.medication_liquid_outlined;
      default:
        return Icons.health_and_safety_outlined;
    }
  }
}
