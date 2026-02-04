import 'package:flutter/material.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF73C6D9);

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();
  final TextEditingController _bhytController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedGender = 'Nam'; // Default
  String? _selectedEthnicity;

  final List<String> _ethnicities = [
    'Kinh', 'Tày', 'Thái', 'Mường', 'Khmer', 'Hoa', 'Nùng', 'H\'Mông', 'Dao', 'Gia Rai', 'Ê Đê', 'Ba Na', 'Xơ Đăng', 'Sán Chay', 'Cơ Ho', 'Chăm', 'Sán Dìu', 'Hrê', 'Ra Glai', 'M\'Nông', 'Xtiêng', 'Bru-Vân Kiều', 'Thổ', 'Khơ Mú', 'Cơ Tu', 'Giáy', 'Giẻ Triêng', 'Tà Ôi', 'Mạ', 'Co', 'Chơ Ro', 'Xinh Mun', 'Hà Nhì', 'Chu Ru', 'Lào', 'Kháng', 'La Chí', 'Phù Lá', 'La Hủ', 'La Ha', 'Pà Thẻn', 'Chứt', 'Lự', 'Lô Lô', 'Mảng', 'Cờ Lao', 'Bố Y', 'Cống', 'Ngái', 'Si La', 'Pu Péo', 'Brâu', 'Rơ Mâm', 'Ơ Đu'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _cccdController.dispose();
    _bhytController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý đăng ký...')),
      );
      // Simulate API call or navigation
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công!')),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Đăng ký bệnh nhân mới',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Vui lòng điền đầy đủ thông tin',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        toolbarHeight: 80, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomTextField(
                label: 'Họ và tên',
                controller: _nameController,
                isRequired: true,
                hintText: 'Nhập họ và tên bệnh nhân',
              ),
              const SizedBox(height: 16),
              
              _buildDateField(),
              const SizedBox(height: 16),

              _buildGenderField(),
              const SizedBox(height: 16),

              _buildCustomTextField(
                label: 'Số CCCD/CMND',
                controller: _cccdController,
                keyboardType: TextInputType.number,
                isRequired: true,
                hintText: 'Nhập số CCCD/CMND',
              ),
              const SizedBox(height: 16),

              _buildCustomTextField(
                label: 'Mã thẻ BHYT',
                controller: _bhytController,
                hintText: 'Nhập mã thẻ BHYT (nếu có)',
              ),
              const SizedBox(height: 16),

              _buildEthnicityDropdown(),
              const SizedBox(height: 16),

              _buildCustomTextField(
                label: 'Số điện thoại',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                isRequired: true,
                hintText: 'Nhập số điện thoại liên hệ',
              ),
              const SizedBox(height: 16),

              _buildCustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Nhập địa chỉ email',
              ),
              const SizedBox(height: 16),

              _buildCustomTextField(
                label: 'Địa chỉ thường trú',
                controller: _addressController,
                maxLines: 3,
                isRequired: true,
                hintText: 'Số nhà, đường, phường/xã, quận/huyện...',
              ),
              const SizedBox(height: 32),

              _buildSubmitButton(),
              const SizedBox(height: 16),
              
              const Center(
                child: Text(
                  'Thông tin của bạn sẽ được bảo mật tuyệt đối theo chính sách của bệnh viện.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: isRequired
                ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập $label';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Ngày sinh',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dobController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn ngày sinh';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                suffixIcon: Icon(Icons.calendar_today, color: _primaryColor),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _primaryColor, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới tính',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('Nam'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption('Nữ'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = _selectedGender == gender;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey[300]!,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEthnicityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dân tộc',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEthnicity,
          decoration: InputDecoration(
            hintText: 'Chọn dân tộc',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _primaryColor, width: 1.5),
            ),
          ),
          items: _ethnicities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedEthnicity = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'TẠO HỒ SƠ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
