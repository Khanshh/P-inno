import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/onboarding_page.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Chào mừng bạn đến với nơi phép màu bắt đầu.',
      'description': 'Từng bước nhỏ cùng bạn hiện thực hóa giấc mơ làm cha mẹ.',
      'icon': Icons.favorite,
      'colors': [
        const Color(0xFF73C6D9), // Xanh ngọc chính
        const Color(0xFF9DD9E8), // Xanh ngọc nhạt
      ],
    },
    {
      'title': 'Chạm vào mầm sống.',
      'description': 'Công nghệ thông minh hỗ trợ các cặp đôi hiếm muộn.',
      'icon': Icons.monitor_heart,
      'colors': [
        const Color(0xFF5BB8CE), // Xanh ngọc đậm hơn
        const Color(0xFF73C6D9), // Xanh ngọc chính
      ],
    },
    {
      'title': 'Luôn có chúng tôi bên cạnh.',
      'description': ' Kết nối chuyên gia, giải đáp mọi thắc mắc của bạn.',
      'icon': Icons.medical_services,
      'colors': [
        const Color(0xFF73C6D9), // Xanh ngọc chính
        const Color(0xFFB8E6F0), // Xanh ngọc rất nhạt
      ],
    },
    {
      'title': 'Hãy để hành trình này trở nên dễ dàng và nhẹ nhàng hơn từ hôm nay.',
      'description': 'Đừng chờ đợi thêm, hãy để hy vọng bắt đầu chuyển hóa thành hành động.',
      'icon': Icons.rocket_launch,
      'colors': [
        const Color(0xFF4DADC2), // Xanh ngọc đậm
        const Color(0xFF73C6D9), // Xanh ngọc chính
      ],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return OnboardingPage(
                title: page['title'],
                description: page['description'],
                icon: page['icon'],
                gradientColors: page['colors'],
              );
            },
          ),

          // Skip button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  'Bỏ qua',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Bottom section with indicator and button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.4),
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Next/Start button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _pages[_currentPage]['colors'][0],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Bắt Đầu Ngay'
                            : 'Tiếp Theo',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
