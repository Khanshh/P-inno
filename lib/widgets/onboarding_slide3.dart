import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingSlide3 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const OnboardingSlide3({super.key, required this.onNext, this.onSkip});

  @override
  State<OnboardingSlide3> createState() => _OnboardingSlide3State();
}

class _OnboardingSlide3State extends State<OnboardingSlide3> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(flex: 3),
                _buildAnimatedContent(),
                const Spacer(flex: 4),
                _buildBottomArea(),
              ],
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
              child: _buildOrb(450, const Color(0xFFE0F7F7).withValues(alpha: 0.6)),
            ),
            Positioned(
              top: 300 - (20 * _backgroundController.value),
              right: -120 + (40 * _backgroundController.value),
              child: _buildOrb(380, const Color(0xFFFAF1E2).withValues(alpha: 0.5)),
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

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _contentController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: widget.onSkip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4E56).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
                ),
                child: Text(
                  'Bỏ qua',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1D4E56),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContent() {
    return Column(
      children: [
        _slideIn(delay: 0.0, child: _buildIconBox()),
        const SizedBox(height: 54),
        _slideIn(
          delay: 0.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Luôn có chúng tôi bên cạnh.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1D4E56),
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _slideIn(
          delay: 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46),
            child: Text(
              "Kết nối chuyên gia, giải đáp mọi thắc mắc của bạn.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1D4E56).withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _slideIn(delay: 0.4, child: _buildIndicator()),
      ],
    );
  }

  Widget _buildIconBox() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.5),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
      ),
      child: Center(
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4E56), Color(0xFF38938F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D4E56).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(4, 8),
              ),
            ],
          ),
          child: const Icon(Icons.medical_services_outlined, size: 55, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 7,
          width: isActive ? 28 : 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive ? const Color(0xFF1D4E56) : const Color(0xFF1D4E56).withValues(alpha: 0.15),
          ),
        );
      }),
    );
  }

  Widget _buildBottomArea() {
    return _slideIn(
      delay: 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Column(
          children: [
            GestureDetector(
              onTap: widget.onNext,
              child: Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D4E56), Color(0xFF2E8B99)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D4E56).withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Bắt đầu ngay',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 12, color: Color(0xFF1D4E56)),
                const SizedBox(width: 8),
                Text(
                  "Thông tin của bạn được bảo mật 100%",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1D4E56).withValues(alpha: 0.5),
                    fontSize: 12,
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

  Widget _slideIn({required double delay, required Widget child}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _contentController,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _contentController,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }
}
