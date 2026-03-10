import 'package:flutter/material.dart';
import '../widgets/onboarding_slide1.dart';
import '../widgets/onboarding_slide2.dart';
import '../widgets/onboarding_slide3.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) { // Có 3 slide: 0, 1, 2
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Cho phép vuốt nhẹ nhàng
        children: [
          OnboardingSlide1(
            onNext: _nextPage,
            onSkip: _finishOnboarding,
          ),
          OnboardingSlide2(
            onNext: _nextPage,
            onSkip: _finishOnboarding,
          ),
          OnboardingSlide3(
            onNext: _finishOnboarding,
            onSkip: _finishOnboarding,
          ),
        ],
      ),
    );
  }
}