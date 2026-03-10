import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'natural_result_screen.dart';
import 'ivf_result_screen.dart';
import '../services/api_service.dart';

class PartnerAssessmentFormScreen extends StatefulWidget {
  final Map<String, dynamic> femaleData;
  const PartnerAssessmentFormScreen({super.key, required this.femaleData});

  @override
  State<PartnerAssessmentFormScreen> createState() => _PartnerAssessmentFormScreenState();
}

class _PartnerAssessmentFormScreenState extends State<PartnerAssessmentFormScreen> {
  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);
  
  final ApiService _apiService = ApiService();

  // Mảng lưu trạng thái của 13 câu
  final TextEditingController _ageCtrl = TextEditingController();

  String? _q2Value = 'Vui lòng chọn';
  String? _q3Value = 'Vui lòng chọn';
  String? _q4Value = 'Vui lòng chọn';
  String? _q5Value = 'Vui lòng chọn';
  String? _q6Value = 'Vui lòng chọn';
  String? _q7Value = 'Vui lòng chọn';
  String? _q8Value = 'Vui lòng chọn';
  String? _q9Value = 'Vui lòng chọn';
  String? _q10Value = 'Vui lòng chọn';
  String? _q11Value = 'Vui lòng chọn';
  String? _q12Value = 'Vui lòng chọn';
  String? _q13Value = 'Vui lòng chọn';

  Map<String, dynamic> _gatherMaleData() {
    return {
      "age": double.tryParse(_ageCtrl.text) ?? 0.0,
      "has_children": _q2Value ?? "",
      "semen_test": _q3Value ?? "",
      "testosterone": _q4Value ?? "",
      "testicular_issues": _q5Value ?? "",
      "varicocele": _q6Value ?? "",
      "erectile_dysfunction": _q7Value ?? "",
      "ejaculation_issues": _q8Value ?? "",
      "smoking": _q9Value ?? "",
      "alcohol": _q10Value ?? "",
      "exercise": _q11Value ?? "",
      "environment": _q12Value ?? "",
      "stress": _q13Value ?? "",
    };
  }

  void _onShowNaturalResultPressed() async {
    // Hiện popup loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: _bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'Đang phân tích dữ liệu tự nhiên...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đợi trong giây lát',
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final maleData = _gatherMaleData();
      final result = await _apiService.runSimulation('hunault', widget.femaleData, maleData);

      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NaturalResultScreen(resultData: result)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _onShowIVFResultPressed() async {
    // Hiện popup loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: _bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'Đang phân tích dữ liệu IVF...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đợi trong giây lát',
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final maleData = _gatherMaleData();
      final result = await _apiService.runSimulation('sart_ivf', widget.femaleData, maleData);

      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => IVFResultScreen(resultData: result)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Thông tin bạn đời',
              style: GoogleFonts.plusJakartaSans(
                color: _primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Bước 2/2',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: _darkShadow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBox(),
                  
                  _buildInputField(
                    question: '1. Bạn bao nhiêu tuổi?',
                    hint: 'VD: 30',
                    controller: _ageCtrl,
                  ),
                  _buildDropdownField(
                    question: '2. Bạn  đã từng có con chưa?',
                    value: _q2Value,
                    options: ["Vui lòng chọn", "Chưa từng", "Đã có"],
                    onChanged: (val) => setState(() => _q2Value = val),
                  ),
                  _buildDropdownField(
                    question: '3. Bạn đã từng làm xét nghiệm tinh dịch đồ (semen analysis) chưa?',
                    value: _q3Value,
                    options: ["Vui lòng chọn", "Chưa từng làm", "Bình thường", "Bất thường"],
                    onChanged: (val) => setState(() => _q3Value = val),
                  ),
                  _buildDropdownField(
                    question: '4. Bạn có biết chỉ số testosterone (nội tiết tố nam) không?',
                    subtext: 'Nếu đã xét nghiệm, vui lòng cho biết kết quả.',
                    value: _q4Value,
                    options: ["Vui lòng chọn", "Bình thường", "Thấp", "Cao", "Không rõ"],
                    onChanged: (val) => setState(() => _q4Value = val),
                  ),
                  _buildDropdownField(
                    question: '5. Bạn có từng gặp vấn đề về tinh hoàn không?',
                    subtext: 'Ví dụ: tinh hoàn ẩn, chấn thương, viêm...',
                    value: _q5Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q5Value = val),
                  ),
                  _buildDropdownField(
                    question: '6. Bạn có bị giãn tĩnh mạch thừng tinh (varicocele) không?',
                    subtext: 'Giãn tĩnh mạch ở bìu, có thể ảnh hưởng đến chất lượng tinh trùng.',
                    value: _q6Value,
                    options: ["Vui lòng chọn", "Không", "Có", "Không rõ"],
                    onChanged: (val) => setState(() => _q6Value = val),
                  ),
                  _buildDropdownField(
                    question: '7. Bạn có gặp vấn đề về rối loạn cương dương không?',
                    value: _q7Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q7Value = val),
                  ),
                  _buildDropdownField(
                    question: '8. Bạn có gặp vấn đề về xuất tinh không?',
                    subtext: 'Ví dụ: xuất tinh sớm, xuất tinh ngược...',
                    value: _q8Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q8Value = val),
                  ),
                  _buildDropdownField(
                    question: '9. Tình trạng hút thuốc lá của bạn?',
                    value: _q9Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q9Value = val),
                  ),
                  _buildDropdownField(
                    question: '10. Bạn có uống rượu/bia thường xuyên không?',
                    value: _q10Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q10Value = val),
                  ),
                  _buildDropdownField(
                    question: '11. Bạn tập thể dục bao nhiêu lần/tuần?',
                    value: _q11Value,
                    options: ["Vui lòng chọn", "Ít vận động", "1-2 lần", "3-4 lần", "Hàng ngày"],
                    onChanged: (val) => setState(() => _q11Value = val),
                  ),
                  _buildDropdownField(
                    question: '12. Môi trường làm việc của bạn ?',
                    subtext: 'Một số môi trường có thể ảnh hưởng đến khả năng sinh sản.',
                    value: _q12Value,
                    options: ["Vui lòng chọn", "Văn phòng (Ít độc hại)", "Tiếp xúc hóa chất/Nhiệt độ cao", "Khác"],
                    onChanged: (val) => setState(() => _q12Value = val),
                  ),
                  _buildDropdownField(
                    question: '13. Mức độ căng thẳng (stress) của bạn ?',
                    value: _q13Value,
                    options: ["Vui lòng chọn", "Thấp", "Trung bình", "Cao"],
                    onChanged: (val) => setState(() => _q13Value = val),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          _buildFooterButtons(),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accentColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_outline_rounded, color: _primaryColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Phần này dành cho bạn đời (nam giới) của bạn. Vui lòng nhập thông tin của người đó.',
              style: GoogleFonts.plusJakartaSans(
                color: _primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String question,
    required String hint,
    required TextEditingController controller,
    String? subtext,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 10, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-4, -4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
              height: 1.4,
            ),
          ),
          if (subtext != null) ...[
            const SizedBox(height: 4),
            Text(
              subtext,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 6, offset: const Offset(3, 3), blurStyle: BlurStyle.inner),
                BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-3, -3), blurStyle: BlurStyle.inner),
              ],
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.plusJakartaSans(fontSize: 15, color: _primaryColor, fontWeight: FontWeight.w600),
              onChanged: (v) => setState(() {}),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String question,
    String? subtext,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 10, offset: const Offset(4, 4)),
          BoxShadow(color: _lightShadow, blurRadius: 10, offset: const Offset(-4, -4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
              height: 1.4,
            ),
          ),
          if (subtext != null) ...[
            const SizedBox(height: 4),
            Text(
              subtext,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 6, offset: const Offset(3, 3), blurStyle: BlurStyle.inner),
                BoxShadow(color: _lightShadow, blurRadius: 6, offset: const Offset(-3, -3), blurStyle: BlurStyle.inner),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: _accentColor),
              iconSize: 24,
              dropdownColor: _bgColor,
              style: GoogleFonts.plusJakartaSans(fontSize: 15, color: _primaryColor, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: InputBorder.none,
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: _darkShadow.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _primaryColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: _onShowNaturalResultPressed,
                    child: Center(
                      child: Text(
                        'Xem kết quả Tự nhiên',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _onShowIVFResultPressed,
                    child: Center(
                      child: Text(
                        'Xem kết quả IVF',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_rounded, size: 14, color: _primaryColor.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  'Miễn phí • Bảo mật thông tin cá nhân',
                  style: GoogleFonts.plusJakartaSans(
                    color: _primaryColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
