import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'account_info_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  UserProfileModel? _profile;
  bool _isLoading = true;
  String? _error;
  
  late AnimationController _backgroundController;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);

  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadProfile();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _apiService.getMyProfile();
      setState(() {
        _profile = profile;
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
              _buildHeader(context),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildMenuCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Thông tin cá nhân',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountInfoScreen()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.star_outline_rounded,
                      title: 'Đánh giá ứng dụng',
                      onTap: () {},
                    ),
                    _buildMenuCard(
                      icon: Icons.volunteer_activism_rounded,
                      title: 'Sứ mệnh của chúng tôi',
                      onTap: () => _showMission(context),
                    ),
                    _buildMenuCard(
                      icon: Icons.policy_outlined,
                      title: 'Điều khoản & Chính sách',
                      onTap: () => _showTerms(context),
                    ),
                    _buildMenuCard(
                      icon: Icons.exit_to_app_rounded,
                      title: 'Đăng xuất',
                      isLogout: true,
                      onTap: () => _handleLogout(context),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'Phiên bản 1.0.0',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.blueGrey.shade400,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
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
              top: -120 + (40 * _backgroundController.value),
              left: -80 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD6F3F3).withOpacity(0.6)),
            ),
            Positioned(
              top: 250 - (30 * _backgroundController.value),
              right: -100 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFFEF9E7).withOpacity(0.5)),
            ),
            Positioned(
              bottom: -150 + (50 * _backgroundController.value),
              left: -50 - (20 * _backgroundController.value),
              child: _buildOrb(500, const Color(0xFFF5EFDF).withOpacity(0.7)),
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

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5)
        ),
        title: Text(
          'Đăng xuất',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade700,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.blueGrey.shade400,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đang đăng xuất...', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  backgroundColor: _primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              elevation: 4,
              shadowColor: const Color(0xFFE53935).withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Đăng xuất',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMission(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _darkShadow.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _darkShadow,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Sứ mệnh của chúng tôi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'P-inno sinh ra với sứ mệnh đồng hành cùng các cặp đôi trên hành trình tìm kiếm thiên chức làm cha mẹ.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: 32),
                _buildMissionItem(Icons.favorite_rounded, 'Tận tâm phục vụ', 'Luôn đặt sức khỏe và hạnh phúc của gia đình bạn lên hàng đầu.'),
                _buildMissionItem(Icons.science_rounded, 'Khoa học hiện đại', 'Cung cấp thông tin và giải pháp y tế dựa trên bằng chứng khoa học mới nhất.'),
                _buildMissionItem(Icons.people_alt_rounded, 'Cộng đồng gắn kết', 'Xây dựng mạng lưới hỗ trợ, nơi mọi người có thể chia sẻ và cùng nhau vượt qua khó khăn.'),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 6,
                      shadowColor: _primaryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      'Đóng',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.blueGrey.shade600,
                    height: 1.5,
                    fontSize: 15,
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

  void _showTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _darkShadow.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _darkShadow,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Điều khoản & Chính sách',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTermSection(
                  '1. Giới thiệu',
                  'Chào mừng bạn đến với P-inno. Bằng cách sử dụng ứng dụng, bạn đồng ý với các điều khoản dưới đây.',
                ),
                const SizedBox(height: 20),
                _buildTermSection(
                  '2. Bảo mật thông tin',
                  'Chúng tôi cam kết bảo mật tuyệt đối thông tin y tế và dữ liệu cá nhân của bạn. Dữ liệu chỉ được sử dụng cho mục đích tư vấn và hỗ trợ chuyên môn.',
                ),
                const SizedBox(height: 20),
                _buildTermSection(
                  '3. Quyền và nghĩa vụ',
                  'Người dùng có trách nhiệm cung cấp thông tin chính xác để nhận được sự tư vấn tốt nhất từ đội ngũ chuyên gia.',
                ),
                const SizedBox(height: 20),
                _buildTermSection(
                  '4. Giới hạn trách nhiệm',
                  'Các thông tin trên ứng dụng mang tính chất tham khảo. Bạn nên thảo luận trực tiếp với bác sĩ điều trị trước khi ra quyết định y tế.',
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _primaryColor, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white.withOpacity(0.5),
                    ),
                    child: Text(
                      'Tôi đã hiểu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTermSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Glassmorphism background component
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                  border: Border.all(color: Colors.white, width: 2), // Ring
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, size: 36, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _profile?.fullName ?? 'Nguyễn Văn A',
                      style: GoogleFonts.plusJakartaSans(
                        color: _primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _primaryColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        _profile != null ? 'Thành viên chính thức' : 'Chưa cập nhật thông tin',
                        style: GoogleFonts.plusJakartaSans(
                          color: _primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon, 
    required String title, 
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Transparent base
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.5), // Glass border
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(6, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 12,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLogout ? const Color(0xFFE53935).withOpacity(0.1) : _accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon, 
                    color: isLogout ? const Color(0xFFE53935) : _primaryColor, 
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isLogout ? const Color(0xFFE53935) : _primaryColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded, 
                  size: 16, 
                  color: Colors.blueGrey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
