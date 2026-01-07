import 'package:flutter/material.dart';
import '../widgets/login_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Stack(
        children: [
          // Header background
          _buildHeader(),
          // Body content with overlap
          _buildBody(context),
          // Back button
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF73C6D9),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hồ Sơ Cá Nhân',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Quản lý thông tin và tài khoản của bạn',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 160), // Space for header overlap
          // Card 1: Trạng thái chưa đăng nhập
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildLoginCard(context),
          ),
          const SizedBox(height: 20),
          // Card 2: Lợi ích đăng nhập
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildBenefitsCard(),
          ),
          const SizedBox(height: 20),
          // Card 3: Bảo mật
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSecurityCard(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Chưa có thông tin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đăng nhập để xem và quản lý hồ sơ của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF9B59B6),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ElevatedButton(
              onPressed: () {
                LoginDialog.show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đăng nhập để tiếp tục',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    final List<_BenefitItem> benefits = const [
      _BenefitItem(
        icon: Icons.description_outlined,
        text: 'Lưu trữ hồ sơ y tế an toàn',
      ),
      _BenefitItem(
        icon: Icons.favorite_outline,
        text: 'Theo dõi chỉ số sức khỏe',
      ),
      _BenefitItem(
        icon: Icons.favorite_border,
        text: 'Nhận lời khuyên cá nhân hóa',
      ),
      _BenefitItem(
        icon: Icons.notifications_outlined,
        text: 'Nhắc nhở lịch khám định kỳ',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6).withOpacity(0.5), // Lavender nhạt
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3), // Xanh dương đậm
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tại sao cần đăng nhập?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      benefit.icon,
                      size: 22,
                      color: const Color(0xFF4A90E2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        benefit.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.shade300,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Thông tin của bạn được mã hóa và bảo mật tuyệt đối',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitItem {
  const _BenefitItem({required this.icon, required this.text});

  final IconData icon;
  final String text;
}

