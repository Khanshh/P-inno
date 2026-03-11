import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _darkShadow = const Color(0xFFD1D9E6);

  String _selectedGender = 'Nữ';
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Wrap(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Chụp ảnh mới',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                _buildPickerOption(
                  icon: Icons.image_rounded,
                  title: 'Chọn từ thư viện',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _accentColor, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon, {bool isReadOnlyField = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.plusJakartaSans(
        color: isReadOnlyField ? Colors.grey.shade400 : _primaryColor.withOpacity(0.6),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: isReadOnlyField ? Colors.grey.shade300 : _accentColor, size: 22),
      filled: true,
      fillColor: isReadOnlyField ? Colors.grey.shade50.withOpacity(0.5) : Colors.white.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _accentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                  child: Column(
                    children: [
                      // Profile Avatar Section
                      _buildAvatarSection(),
                      const SizedBox(height: 32),

                      // Form Section
                      _buildGlassCard(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: 'Nguyễn Thị A',
                              readOnly: true,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _buildInputDecoration('Họ và tên', Icons.person_outline_rounded, isReadOnlyField: true),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: _buildInputDecoration('Giới tính', Icons.transgender_rounded, isReadOnlyField: true),
                              icon: Icon(Icons.lock_outline_rounded, size: 18, color: Colors.grey.shade300),
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: '01/01/1995',
                              readOnly: true,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _buildInputDecoration('Ngày sinh', Icons.calendar_today_rounded, isReadOnlyField: true),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: 'nguyenthia@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              readOnly: !_isEditingEmail,
                              style: GoogleFonts.plusJakartaSans(
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _buildInputDecoration('Email', Icons.email_outlined).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isEditingEmail ? Icons.check_circle_rounded : Icons.edit_rounded,
                                    color: _isEditingEmail ? Colors.green : _accentColor,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditingEmail = !_isEditingEmail;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: '0987654321',
                              keyboardType: TextInputType.phone,
                              readOnly: !_isEditingPhone,
                              style: GoogleFonts.plusJakartaSans(
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _buildInputDecoration('Số điện thoại', Icons.phone_android_rounded).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isEditingPhone ? Icons.check_circle_rounded : Icons.edit_rounded,
                                    color: _isEditingPhone ? Colors.green : _accentColor,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditingPhone = !_isEditingPhone;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Update Button
                      _buildUpdateHeroButton(),
                    ],
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
              top: 200 + (30 * _backgroundController.value),
              right: -100 + (25 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFD1E2F1).withOpacity(0.4)),
            ),
            Positioned(
              bottom: 150 + (40 * _backgroundController.value),
              left: -120 + (20 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD1F1D1).withOpacity(0.5)),
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
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
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
        bottom: 32,
      ),
      child: Row(
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
              child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Thông tin tài khoản',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: () => _showPicker(context),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [_accentColor, const Color(0xFFE2F1AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: _bgColor,
                  backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_enhance_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateHeroButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Cập nhật thông tin thành công!',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
              backgroundColor: _primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          'CẬP NHẬT THÔNG TIN',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
