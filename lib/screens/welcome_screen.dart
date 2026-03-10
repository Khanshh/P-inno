import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF), // Ivory background like Onboarding
      body: Stack(
        children: [
          // 1. Aura Background (Modern Mesh Gradient)
          _buildAuraBackground(context),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3), // Push content down a bit
                _buildCenterContent(),
                const SizedBox(height: 64), // Space between logo cluster and buttons
                _buildBottomButtons(context),
                const Spacer(flex: 3), // Bottom padding to keep buttons near center-bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuraBackground(BuildContext context) {
    return Stack(
      children: [
        // Top Left Cyan Orb
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD6F3F3).withValues(alpha: 0.6),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Bottom Right Warm Gold Orb
        Positioned(
          bottom: -150,
          right: -50,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5EFDF).withValues(alpha: 0.7),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedLogo(),
        const SizedBox(height: 24),
        Text(
          'ENA',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1D4E56), // Deep Teal
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Đồng hành cùng hành trình\nIVF của bạn',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: const Color(0xFF1D4E56).withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.5),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
        ),
        child: Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Primary Button - Gradient Login
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4E56), Color(0xFF2E8B99)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4E56).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Đăng nhập',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Secondary Button - Subtle Register
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'Đăng ký tài khoản mới',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1D4E56),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
