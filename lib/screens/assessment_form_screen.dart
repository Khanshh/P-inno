import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'partner_assessment_form_screen.dart';

class AssessmentFormScreen extends StatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  State<AssessmentFormScreen> createState() => _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends State<AssessmentFormScreen> {
  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  // Mảng lưu trạng thái của 20 câu
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

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
  String? _q14Value = 'Vui lòng chọn';
  String? _q15Value = 'Vui lòng chọn';
  String? _q16Value = 'Vui lòng chọn';
  String? _q17Value = 'Vui lòng chọn';
  String? _q18Value = 'Vui lòng chọn';
  String? _q19Value = 'Vui lòng chọn';
  String? _q20Value = 'Vui lòng chọn';

  int _countFilled() {
    int count = 0;
    if (_ageCtrl.text.trim().isNotEmpty) count++;
    if (_heightCtrl.text.trim().isNotEmpty) count++;
    if (_weightCtrl.text.trim().isNotEmpty) count++;
    if (_q4Value != 'Vui lòng chọn') count++;
    if (_q5Value != 'Vui lòng chọn') count++;
    if (_q6Value != 'Vui lòng chọn') count++;
    if (_q7Value != 'Vui lòng chọn') count++;
    if (_q8Value != 'Vui lòng chọn') count++;
    if (_q9Value != 'Vui lòng chọn') count++;
    if (_q10Value != 'Vui lòng chọn') count++;
    if (_q11Value != 'Vui lòng chọn') count++;
    if (_q12Value != 'Vui lòng chọn') count++;
    if (_q13Value != 'Vui lòng chọn') count++;
    if (_q14Value != 'Vui lòng chọn') count++;
    if (_q15Value != 'Vui lòng chọn') count++;
    if (_q16Value != 'Vui lòng chọn') count++;
    if (_q17Value != 'Vui lòng chọn') count++;
    if (_q18Value != 'Vui lòng chọn') count++;
    if (_q19Value != 'Vui lòng chọn') count++;
    if (_q20Value != 'Vui lòng chọn') count++;
    return count;
  }

  void _onContinuePressed() {
    final femaleData = {
      "age": double.tryParse(_ageCtrl.text) ?? 0.0,
      "height": double.tryParse(_heightCtrl.text) ?? 0.0,
      "weight": double.tryParse(_weightCtrl.text) ?? 0.0,
      "trying_duration": _q4Value ?? "",
      "pregnancy_count": _q5Value ?? "",
      "live_births": _q6Value ?? "",
      "miscarriages": _q7Value ?? "",
      "done_ivf": _q8Value ?? "",
      "menstrual_cycle": _q9Value ?? "",
      "tracking_ovulation": _q10Value ?? "",
      "amh_level": _q11Value ?? "",
      "afc_count": _q12Value ?? "",
      "hsg_result": _q13Value ?? "",
      "has_pcos": _q14Value ?? "",
      "has_endometriosis": _q15Value ?? "",
      "has_thyroid_issues": _q16Value ?? "",
      "smoking": _q17Value ?? "",
      "alcohol": _q18Value ?? "",
      "exercise": _q19Value ?? "",
      "stress": _q20Value ?? "",
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PartnerAssessmentFormScreen(femaleData: femaleData),
      ),
    );
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int filled = _countFilled();
    double progress = filled / 20.0;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông tin của bạn',
          style: GoogleFonts.plusJakartaSans(
            color: _primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: (MediaQuery.of(context).size.width - 48) * progress,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$filled/20',
                  style: GoogleFonts.plusJakartaSans(
                    color: _primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
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
                  _buildInputField(
                    question: '1. Bạn bao nhiêu tuổi?',
                    hint: 'VD: 28',
                    controller: _ageCtrl,
                  ),
                  _buildInputField(
                    question: '2. Chiều cao của bạn?',
                    hint: 'cm',
                    controller: _heightCtrl,
                  ),
                  _buildInputField(
                    question: '3. Cân nặng của bạn?',
                    hint: 'kg',
                    controller: _weightCtrl,
                  ),
                  _buildDropdownField(
                    question: '4. Bạn và bạn đời đã cố gắng có con được bao lâu?',
                    value: _q4Value,
                    options: ["Vui lòng chọn", "Dưới 6 tháng", "6-12 tháng", "1-2 năm", "2-3 năm", "Trên 3 năm"],
                    onChanged: (val) => setState(() => _q4Value = val),
                  ),
                  _buildDropdownField(
                    question: '5. Bạn đã mang thai bao nhiêu lần?',
                    value: _q5Value,
                    options: ["Vui lòng chọn", "Chưa từng", "1 lần", "2 lần", "3 lần trở lên"],
                    onChanged: (val) => setState(() => _q5Value = val),
                  ),
                  _buildDropdownField(
                    question: '6. Bạn đã sinh con đủ tháng bao nhiêu lần?',
                    value: _q6Value,
                    options: ["Vui lòng chọn", "0", "1", "2", "3 trở lên"],
                    onChanged: (val) => setState(() => _q6Value = val),
                  ),
                  _buildDropdownField(
                    question: '7. Bạn đã bao giờ bị sảy thai chưa?',
                    value: _q7Value,
                    options: ["Vui lòng chọn", "Chưa từng", "1 lần", "2 lần", "Từ 3 lần trở lên"],
                    onChanged: (val) => setState(() => _q7Value = val),
                  ),
                  _buildDropdownField(
                    question: '8. Bạn đã từng làm IVF (Thụ tinh trong ống nghiệm) chưa?',
                    value: _q8Value,
                    options: ["Vui lòng chọn", "Chưa từng", "Đã từng làm"],
                    onChanged: (val) => setState(() => _q8Value = val),
                  ),
                  _buildDropdownField(
                    question: '9. Chu kỳ kinh nguyệt của bạn có đều đặn không?',
                    value: _q9Value,
                    options: ["Vui lòng chọn", "Đều đặn", "Không đều", "Không có kinh"],
                    onChanged: (val) => setState(() => _q9Value = val),
                  ),
                  _buildDropdownField(
                    question: '10. Bạn có theo dõi ngày rụng trứng không?',
                    value: _q10Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q10Value = val),
                  ),
                  _buildDropdownField(
                    question: '11. Chỉ số AMH của bạn?',
                    value: _q11Value,
                    options: ["Vui lòng chọn", "Bình thường (1.0 - 4.0)", "Thấp (< 1.0)", "Cao (> 4.0)", "Không rõ"],
                    onChanged: (val) => setState(() => _q11Value = val),
                  ),
                  _buildDropdownField(
                    question: '12. Số lượng nang noãn (AFC) của bạn?',
                    value: _q12Value,
                    options: ["Vui lòng chọn", "Bình thường", "Thấp", "Cao", "Không rõ"],
                    onChanged: (val) => setState(() => _q12Value = val),
                  ),
                  _buildDropdownField(
                    question: '13. Bạn đã làm chụp tử cung vòi trứng (HSG) chưa?',
                    value: _q13Value,
                    options: ["Vui lòng chọn", "Chưa làm", "Bình thường", "Tắc nghẽn"],
                    onChanged: (val) => setState(() => _q13Value = val),
                  ),
                  _buildDropdownField(
                    question: '14. Bạn có bị hội chứng buồng trứng đa nang (PCOS) không?',
                    value: _q14Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q14Value = val),
                  ),
                  _buildDropdownField(
                    question: '15. Bạn có bị lạc nội mạc tử cung không?',
                    value: _q15Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q15Value = val),
                  ),
                  _buildDropdownField(
                    question: '16. Bạn có vấn đề về tuyến giáp không?',
                    value: _q16Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q16Value = val),
                  ),
                  _buildDropdownField(
                    question: '17. Bạn có hút thuốc không?',
                    value: _q17Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q17Value = val),
                  ),
                  _buildDropdownField(
                    question: '18. Bạn có uống rượu bia không?',
                    value: _q18Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q18Value = val),
                  ),
                  _buildDropdownField(
                    question: '19. Bạn tập thể dục bao nhiêu lần/tuần?',
                    value: _q19Value,
                    options: ["Vui lòng chọn", "Ít vận động", "1-2 lần", "3-4 lần", "Hàng ngày"],
                    onChanged: (val) => setState(() => _q19Value = val),
                  ),
                  _buildDropdownField(
                    question: '20. Mức độ căng thẳng (stress) của bạn?',
                    value: _q20Value,
                    options: ["Vui lòng chọn", "Thấp", "Trung bình", "Cao"],
                    onChanged: (val) => setState(() => _q20Value = val),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          
          _buildFooterButton(context),
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
  
  Widget _buildFooterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _accentColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _onContinuePressed,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tiếp tục',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
