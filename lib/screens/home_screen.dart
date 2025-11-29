import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_profile_provider.dart';
import 'health_profile_screen.dart';
import 'chatbot_screen.dart';
import 'ivf_iui_screen.dart';
import 'couple_screen.dart';
import 'flo_style_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FloStyleDashboard(),
    const HealthProfileScreen(),
    const ChatbotScreen(),
    const IVFIUIScreen(),
    const CoupleScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF7FB3D3).withValues(alpha: 0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey[400]),
              selectedIcon: const Icon(Icons.home, color: Color(0xFF7FB3D3)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.grey[400]),
              selectedIcon: const Icon(Icons.person, color: Color(0xFF7FB3D3)),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline, color: Colors.grey[400]),
              selectedIcon: const Icon(Icons.chat_bubble, color: Color(0xFF7FB3D3)),
              label: 'Consult',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline, color: Colors.grey[400]),
              selectedIcon: const Icon(Icons.favorite, color: Color(0xFFE8B4B8)),
              label: 'IVF/IUI',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline, color: Colors.grey[400]),
              selectedIcon: const Icon(Icons.people, color: Color(0xFF7FB3D3)),
              label: 'Couple',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<HealthProfileProvider>().profile;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('P-Inno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card - Soft Minimalism
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFA8D5E2).withValues(alpha: 0.3),
                    const Color(0xFFF4C2C2).withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile != null 
                        ? 'Xin chào, ${profile.name}! 👋'
                        : 'Chào mừng đến với P-Inno! 👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hỗ trợ sức khỏe thai sản cho cả nam và nữ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Quick Actions
            Text(
              'Tính năng nổi bật',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.05,
              children: [
                _FeatureCard(
                  icon: Icons.person,
                  title: 'Hồ sơ sức khỏe',
                  color: const Color(0xFFA8D5E2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HealthProfileScreen(),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon: Icons.chat_bubble,
                  title: 'Chatbot tư vấn',
                  color: const Color(0xFFB8E6D3),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatbotScreen(),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon: Icons.favorite,
                  title: 'Hỗ trợ IVF/IUI',
                  color: const Color(0xFFF4C2C2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const IVFIUIScreen(),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon: Icons.people,
                  title: 'Cặp đôi',
                  color: const Color(0xFFD4B5E8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoupleScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Health Summary
            if (profile != null) ...[
              const SizedBox(height: 8),
              Text(
                'Tóm tắt sức khỏe',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _HealthSummaryRow(
                        label: 'Tuổi',
                        value: profile.age?.toString() ?? 'Chưa cập nhật',
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1, color: const Color(0xFFE8E8E8)),
                      const SizedBox(height: 16),
                      _HealthSummaryRow(
                        label: 'Giới tính',
                        value: profile.gender == 'female' ? 'Nữ' : 'Nam',
                      ),
                      if (profile.bmi != null) ...[
                        const SizedBox(height: 16),
                        Container(height: 1, color: const Color(0xFFE8E8E8)),
                        const SizedBox(height: 16),
                        _HealthSummaryRow(
                          label: 'BMI',
                          value: profile.bmi!.toStringAsFixed(1),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthSummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _HealthSummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF718096),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}

