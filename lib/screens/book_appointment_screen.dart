import 'package:flutter/material.dart';
import 'appointment_success_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? patientData; // Info from previous screen if available

  const BookAppointmentScreen({super.key, this.patientData});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF73C6D9);

  // Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedTime;
  String? _selectedDept;

  final List<String> _timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '13:30 - 14:30',
    '14:30 - 15:30',
    '15:30 - 16:30',
  ];

  final List<String> _departments = [
    'Khoa Nội',
    'Khoa Ngoại',
    'Khoa Sản',
    'Khoa Nhi',
    'Khoa Hiếm Muộn',
    'Nam Khoa',
    'Tai Mũi Họng',
    'Răng Hàm Mặt',
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _doctorController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn khung giờ khám')),
        );
        return;
      }
      if (_selectedDept == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn chuyên khoa')),
        );
        return;
      }

      final bookingData = {
        'patientName': widget.patientData?['fullName'] ?? 'Nguyễn Văn A',
        'date': _dateController.text,
        'time': _selectedTime,
        'department': _selectedDept,
        'doctor': _doctorController.text,
        'reason': _reasonController.text,
        'note': _noteController.text,
      };

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AppointmentSuccessScreen(appointmentData: bookingData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Đặt lịch khám',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientInfoCard(),
              const SizedBox(height: 20),
              _buildFormSection(),
              const SizedBox(height: 20),
              _buildWarningBox(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'XÁC NHẬN ĐẶT LỊCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, color: _primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientData?['fullName'] ?? 'Nguyễn Văn A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                 Text(
                  '${widget.patientData?['gender'] ?? 'Nam'} • ${widget.patientData?['dob'] ?? '1990'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildDateField(),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Khung giờ khám *',
          hint: 'Chọn khung giờ',
          value: _selectedTime,
          items: _timeSlots,
          onChanged: (val) {
            setState(() {
              _selectedTime = val;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Chuyên khoa *',
          hint: 'Chọn chuyên khoa',
          value: _selectedDept,
          items: _departments,
          onChanged: (val) {
            setState(() {
              _selectedDept = val;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Bác sĩ mong muốn (Tùy chọn)',
          controller: _doctorController,
          hint: 'Nhập tên bác sĩ',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Lý do khám *',
          controller: _reasonController,
          hint: 'Mô tả triệu chứng hoặc lý do...',
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
         _buildTextField(
          label: 'Ghi chú thêm',
          controller: _noteController,
          hint: 'Lưu ý cho bác sĩ...',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isRequired = false,
    int maxLines = 1,
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
          maxLines: maxLines,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thông tin này';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
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
            text: 'Ngày khám',
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
              controller: _dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn ngày khám';
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

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE), // Light Blue
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.info, color: Color(0xFF73C6D9), size: 20),
              SizedBox(width: 8),
              Text(
                'Lưu ý quan trọng',
                style: TextStyle(
                  color: Color(0xFF0277BD),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '- Vui lòng đến trước giờ hẹn 15 phút.\n- Mang theo CMND/CCCD và thẻ BHYT khi đi khám.\n- Đeo khẩu trang trong suốt quá trình thăm khám.',
            style: TextStyle(
              color: Color(0xFF01579B),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
