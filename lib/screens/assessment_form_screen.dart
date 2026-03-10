import 'package:flutter/material.dart';
import 'simulation_screen.dart';
import 'partner_assessment_form_screen.dart';

class AssessmentFormScreen extends StatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  State<AssessmentFormScreen> createState() => _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends State<AssessmentFormScreen> {
  static const Color _primaryColor = Color(0xFF73C6D9);

  // Mảng lưu trạng thái của 20 câu
  // Câu 1-3
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  // Câu 4-20
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
    // Collect data
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin của bạn',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Linear Progress Indicator
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    question: 'Câu 1: Bạn bao nhiêu tuổi?',
                    hint: 'VD: 28',
                    controller: _ageCtrl,
                  ),
                  _buildInputField(
                    question: 'Câu 2: Chiều cao của bạn?',
                    hint: 'cm',
                    controller: _heightCtrl,
                  ),
                  _buildInputField(
                    question: 'Câu 3: Cân nặng của bạn?',
                    hint: 'kg',
                    controller: _weightCtrl,
                  ),
                  _buildDropdownField(
                    question: 'Câu 4: Bạn và bạn đời đã cố gắng có con được bao lâu?',
                    value: _q4Value,
                    options: ["Vui lòng chọn", "Dưới 6 tháng", "6-12 tháng", "1-2 năm", "2-3 năm", "Trên 3 năm"],
                    onChanged: (val) => setState(() => _q4Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 5: Bạn đã mang thai bao nhiêu lần?',
                    value: _q5Value,
                    options: ["Vui lòng chọn", "Chưa từng", "1 lần", "2 lần", "3 lần trở lên"],
                    onChanged: (val) => setState(() => _q5Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 6: Bạn đã sinh con đủ tháng bao nhiêu lần?',
                    value: _q6Value,
                    options: ["Vui lòng chọn", "0", "1", "2", "3 trở lên"],
                    onChanged: (val) => setState(() => _q6Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 7: Bạn đã bao giờ bị sảy thai chưa?',
                    value: _q7Value,
                    options: ["Vui lòng chọn", "Chưa từng", "1 lần", "2 lần", "Từ 3 lần trở lên"],
                    onChanged: (val) => setState(() => _q7Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 8: Bạn đã từng làm IVF (Thụ tinh trong ống nghiệm) chưa?',
                    value: _q8Value,
                    options: ["Vui lòng chọn", "Chưa từng", "Đã từng làm"],
                    onChanged: (val) => setState(() => _q8Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 9: Chu kỳ kinh nguyệt của bạn có đều đặn không?',
                    value: _q9Value,
                    options: ["Vui lòng chọn", "Đều đặn", "Không đều", "Không có kinh"],
                    onChanged: (val) => setState(() => _q9Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 10: Bạn có theo dõi ngày rụng trứng không?',
                    value: _q10Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q10Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 11: Chỉ số AMH của bạn?',
                    value: _q11Value,
                    options: ["Vui lòng chọn", "Bình thường (1.0 - 4.0)", "Thấp (< 1.0)", "Cao (> 4.0)", "Không rõ"],
                    onChanged: (val) => setState(() => _q11Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 12: Số lượng nang noãn (AFC) của bạn?',
                    value: _q12Value,
                    options: ["Vui lòng chọn", "Bình thường", "Thấp", "Cao", "Không rõ"],
                    onChanged: (val) => setState(() => _q12Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 13: Bạn đã làm chụp tử cung vòi trứng (HSG) chưa?',
                    value: _q13Value,
                    options: ["Vui lòng chọn", "Chưa làm", "Bình thường", "Tắc nghẽn"],
                    onChanged: (val) => setState(() => _q13Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 14: Bạn có bị hội chứng buồng trứng đa nang (PCOS) không?',
                    value: _q14Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q14Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 15: Bạn có bị lạc nội mạc tử cung không?',
                    value: _q15Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q15Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 16: Bạn có vấn đề về tuyến giáp không?',
                    value: _q16Value,
                    options: ["Vui lòng chọn", "Có", "Không"],
                    onChanged: (val) => setState(() => _q16Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 17: Bạn có hút thuốc không?',
                    value: _q17Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q17Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 18: Bạn có uống rượu bia không?',
                    value: _q18Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q18Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 19: Bạn tập thể dục bao nhiêu lần/tuần?',
                    value: _q19Value,
                    options: ["Vui lòng chọn", "Ít vận động", "1-2 lần", "3-4 lần", "Hàng ngày"],
                    onChanged: (val) => setState(() => _q19Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 20: Mức độ căng thẳng (stress) của bạn?',
                    value: _q20Value,
                    options: ["Vui lòng chọn", "Thấp", "Trung bình", "Cao"],
                    onChanged: (val) => setState(() => _q20Value = val),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Footer button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onContinuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tiếp tục >',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          if (subtext != null) ...[
            const SizedBox(height: 4),
            Text(
              subtext,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            onChanged: (v) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _primaryColor, width: 1.5),
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
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          if (subtext != null) ...[
            const SizedBox(height: 4),
            Text(
              subtext,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              iconSize: 24,
              dropdownColor: Colors.white,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
}
