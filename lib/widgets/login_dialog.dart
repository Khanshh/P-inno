import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  /// Hàm hiển thị popup
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc user bấm đóng hoặc đăng nhập
      builder: (context) => const LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header
            _buildHeader(context),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. Info Hospital (Card 1)
                  _buildHospitalInfo(),
                  const SizedBox(height: 16),

                  // 3. Notice (Card 2)
                  _buildNotice(),
                  const SizedBox(height: 24),

                  // 4. Form Input
                  _buildTextField(
                    label: 'Tên đăng nhập / Mã bệnh nhân',
                    icon: Icons.person_outline,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Mật khẩu',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // 5. Main Button
                  _buildLoginButton(),
                  
                  const SizedBox(height: 20),

                  // 6. Footer Links
                  _buildFooterLinks(),
                ],
              ),
            ),
            
            // 7. Bottom Disclaimer (Footer)
            _buildBottomDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withOpacity(0.1), // Tím nhạt
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Color(0xFF6A1B9A), // Tím
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Đăng nhập hệ thống',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.grey),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5), // Hồng rất nhạt
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.business, color: Color(0xFFAD1457), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bệnh viện Phụ Sản Trung ương',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF880E4F),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '43 Tràng Thi, Hoàn Kiếm, Hà Nội',
                  style: TextStyle(
                    color: const Color(0xFF880E4F).withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Xanh dương nhạt
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF90CAF9).withOpacity(0.5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vui lòng sử dụng tài khoản được bệnh viện cấp để đăng nhập và theo dõi hồ sơ sức khỏe.',
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Nhập $label...',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8E24AA), // Tím
            Color(0xFFD81B60), // Hồng đậm
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD81B60).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Mock action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Quên mật khẩu?',
            style: TextStyle(
              color: Color(0xFF8E24AA),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('hoặc', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Liên hệ bệnh viện để được cấp tài khoản',
            style: TextStyle(
              color: Color(0xFF8E24AA),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDE7), // Vàng nhạt
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Chưa có tài khoản?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF57F17),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vui lòng đến quầy tiếp đón tại bệnh viện để đăng ký hồ sơ điện tử.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFF57F17).withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
