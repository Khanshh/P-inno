import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'account_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  UserProfileModel? _profile;
  bool _isLoading = true;
  String? _error;
  
  // Define the primary color
  final Color _primaryColor = const Color(0xFF73C6D9);

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
      backgroundColor: const Color(0xFFF8F9FA), // Extremely light gray/white
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuCard(
                  icon: Icons.person_outline,
                  title: 'Thông tin tài khoản',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountInfoScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.star_outline,
                  title: 'Đánh giá ứng dụng',
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.volunteer_activism_outlined,
                  title: 'Sứ mệnh của chúng tôi',
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.policy_outlined,
                  title: 'Điều khoản & Chính sách',
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.exit_to_app,
                  title: 'Đăng xuất',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12), // Push content to match design
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 25, color: Colors.grey[400]),
                  // Use _profile?.avatarUrl if available
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _profile?.fullName ?? 'Nguyễn Văn A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _profile != null ? 'Thành viên chính thức' : 'Chưa cập nhật thông tin',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF73C6D9).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF73C6D9), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
