import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _backgroundController;

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
    _nameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đăng ký thành công!',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: const Color(0xFF1D4E56),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeMainScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Có lỗi xảy ra, vui lòng thử lại',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildAnimatedLogo(),
                    const SizedBox(height: 24),
                    _buildTextHeader(),
                    const SizedBox(height: 32),
                    _buildInputFields(),
                    const SizedBox(height: 48),
                    _buildRegisterButton(),
                    const SizedBox(height: 32),
                    _buildBottomLogin(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
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
              top: -120 + (40 * _backgroundController.value),
              left: -80 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD6F3F3).withValues(alpha: 0.6)),
            ),
            Positioned(
              top: 250 - (30 * _backgroundController.value),
              right: -100 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFFEF9E7).withValues(alpha: 0.5)),
            ),
            Positioned(
              bottom: -150 + (50 * _backgroundController.value),
              left: -50 - (20 * _backgroundController.value),
              child: _buildOrb(500, const Color(0xFFF5EFDF).withValues(alpha: 0.7)),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1D4E56).withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
          ),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1D4E56), size: 24),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTextHeader() {
    return Column(
      children: [
        Text(
          'Đăng ký',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1D4E56),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tham gia cùng chúng tôi hôm nay',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: const Color(0xFF1D4E56).withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // Name field
        _buildTextField(
          controller: _nameController,
          hint: 'Họ và tên',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        // Email field
        _buildTextField(
          controller: _emailController,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Phone field
        _buildTextField(
          controller: _phoneController,
          hint: 'Số điện thoại',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          prefixText: '+84 | ',
        ),
        const SizedBox(height: 16),
        // Birth Date field
        _buildDateField(),
        const SizedBox(height: 16),
        // Password field
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF1D4E56)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF1D4E56).withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: const Color(0xFF1D4E56).withValues(alpha: 0.7)),
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Color(0xFF1D4E56), fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1D4E56)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Vui lòng điền thông tin';
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      style: const TextStyle(color: Color(0xFF1D4E56)),
      decoration: InputDecoration(
        hintText: 'Ngày sinh',
        hintStyle: TextStyle(color: const Color(0xFF1D4E56).withValues(alpha: 0.5)),
        prefixIcon: Icon(Icons.calendar_today_outlined, color: const Color(0xFF1D4E56).withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1D4E56)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1D4E56),
                  onPrimary: Colors.white,
                  onSurface: Color(0xFF1D4E56),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _birthDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          });
        }
      },
      validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng chọn ngày sinh' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Color(0xFF1D4E56)),
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        hintStyle: TextStyle(color: const Color(0xFF1D4E56).withValues(alpha: 0.5)),
        prefixIcon: Icon(Icons.lock_outline, color: const Color(0xFF1D4E56).withValues(alpha: 0.7)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF1D4E56).withValues(alpha: 0.7),
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF1D4E56).withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1D4E56)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
        if (value.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D4E56),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF1D4E56).withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đăng ký',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildBottomLogin() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(fontSize: 15, color: const Color(0xFF1D4E56).withValues(alpha: 0.7), fontWeight: FontWeight.w600),
            children: const [
              TextSpan(text: 'Đã có tài khoản? '),
              TextSpan(
                text: 'Đăng nhập',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4E56)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
