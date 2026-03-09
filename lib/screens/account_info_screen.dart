import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final Color _primaryColor = const Color(0xFF73C6D9);
  String _selectedGender = 'Nữ';
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh mới'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon, {bool isReadOnlyField = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: isReadOnlyField,
      fillColor: isReadOnlyField ? Colors.grey.shade100 : Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar
            Center(
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Form Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: 'Nguyễn Thị A',
                    readOnly: true,
                    style: TextStyle(color: Colors.grey.shade600),
                    decoration: _buildInputDecoration('Họ và tên', Icons.person_outline, isReadOnlyField: true),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: _buildInputDecoration('Giới tính', Icons.transgender, isReadOnlyField: true),
                    items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '01/01/1995',
                    readOnly: true,
                    style: TextStyle(color: Colors.grey.shade600),
                    decoration: _buildInputDecoration('Ngày sinh', Icons.calendar_today_outlined, isReadOnlyField: true),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'nguyenthia@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    readOnly: !_isEditingEmail,
                    decoration: _buildInputDecoration('Email', Icons.email_outlined).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.edit, color: _isEditingEmail ? _primaryColor : Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _isEditingEmail = !_isEditingEmail;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '0987654321',
                    keyboardType: TextInputType.phone,
                    readOnly: !_isEditingPhone,
                    decoration: _buildInputDecoration('Số điện thoại', Icons.phone_outlined).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.edit, color: _isEditingPhone ? _primaryColor : Colors.grey, size: 20),
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
            // Footer Button
            Container(
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cập nhật thông tin thành công!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cập nhật thông tin',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
