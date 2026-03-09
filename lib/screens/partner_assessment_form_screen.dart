import 'package:flutter/material.dart';
import 'natural_result_screen.dart';
import 'ivf_result_screen.dart';

class PartnerAssessmentFormScreen extends StatefulWidget {
  const PartnerAssessmentFormScreen({super.key});

  @override
  State<PartnerAssessmentFormScreen> createState() => _PartnerAssessmentFormScreenState();
}

class _PartnerAssessmentFormScreenState extends State<PartnerAssessmentFormScreen> {
  static const Color _primaryColor = Color(0xFF73C6D9);

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

  void _onShowNaturalResultPressed() async {
    // Hiện popup loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Đang phân tích dữ liệu tự nhiên...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đợi trong giây lát',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    Navigator.pop(context); // Close dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NaturalResultScreen()),
    );
  }

  void _onShowIVFResultPressed() async {
    // Hiện popup loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Đang phân tích dữ liệu IVF...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đợi trong giây lát',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    Navigator.pop(context); // Close dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IVFResultScreen()),
    );
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'Thông tin bạn đời',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Bước 2/2',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Linear Progress Indicator
          const LinearProgressIndicator(
            value: 1.0,
            minHeight: 3,
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBox(),
                  
                  _buildInputField(
                    question: 'Câu 1: Bạn bao nhiêu tuổi?',
                    hint: 'VD: 30',
                    controller: _ageCtrl,
                  ),
                  _buildDropdownField(
                    question: 'Câu 2: Bạn  đã từng có con chưa?',
                    value: _q2Value,
                    options: ["Vui lòng chọn", "Chưa từng", "Đã có"],
                    onChanged: (val) => setState(() => _q2Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 3: Bạn đã từng làm xét nghiệm tinh dịch đồ (semen analysis) chưa?',
                    value: _q3Value,
                    options: ["Vui lòng chọn", "Chưa từng làm", "Bình thường", "Bất thường"],
                    onChanged: (val) => setState(() => _q3Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 4: Bạn có biết chỉ số testosterone (nội tiết tố nam) không?',
                    subtext: 'Nếu đã xét nghiệm, vui lòng cho biết kết quả.',
                    value: _q4Value,
                    options: ["Vui lòng chọn", "Bình thường", "Thấp", "Cao", "Không rõ"],
                    onChanged: (val) => setState(() => _q4Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 5: Bạn có từng gặp vấn đề về tinh hoàn không?',
                    subtext: 'Ví dụ: tinh hoàn ẩn, chấn thương, viêm...',
                    value: _q5Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q5Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 6: Bạn có bị giãn tĩnh mạch thừng tinh (varicocele) không?',
                    subtext: 'Giãn tĩnh mạch ở bìu, có thể ảnh hưởng đến chất lượng tinh trùng.',
                    value: _q6Value,
                    options: ["Vui lòng chọn", "Không", "Có", "Không rõ"],
                    onChanged: (val) => setState(() => _q6Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 7: Bạn có gặp vấn đề về rối loạn cương dương không?',
                    value: _q7Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q7Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 8: Bạn có gặp vấn đề về xuất tinh không?',
                    subtext: 'Ví dụ: xuất tinh sớm, xuất tinh ngược...',
                    value: _q8Value,
                    options: ["Vui lòng chọn", "Không", "Có"],
                    onChanged: (val) => setState(() => _q8Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 9: Tình trạng hút thuốc lá của bạn?',
                    value: _q9Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q9Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 10: Bạn có uống rượu/bia thường xuyên không?',
                    value: _q10Value,
                    options: ["Vui lòng chọn", "Không", "Thỉnh thoảng", "Thường xuyên"],
                    onChanged: (val) => setState(() => _q10Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 11: Bạn tập thể dục bao nhiêu lần/tuần?',
                    value: _q11Value,
                    options: ["Vui lòng chọn", "Ít vận động", "1-2 lần", "3-4 lần", "Hàng ngày"],
                    onChanged: (val) => setState(() => _q11Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 12: Môi trường làm việc của bạn ?',
                    subtext: 'Một số môi trường có thể ảnh hưởng đến khả năng sinh sản.',
                    value: _q12Value,
                    options: ["Vui lòng chọn", "Văn phòng (Ít độc hại)", "Tiếp xúc hóa chất/Nhiệt độ cao", "Khác"],
                    onChanged: (val) => setState(() => _q12Value = val),
                  ),
                  _buildDropdownField(
                    question: 'Câu 13: Mức độ căng thẳng (stress) của bạn ?',
                    value: _q13Value,
                    options: ["Vui lòng chọn", "Thấp", "Trung bình", "Cao"],
                    onChanged: (val) => setState(() => _q13Value = val),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Footer buttons
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _onShowNaturalResultPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Xem kết quả Tự nhiên',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onShowIVFResultPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xem kết quả IVF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Miễn phí • Bảo mật thông tin cá nhân',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lightbulb_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Phần này dành cho bạn đời (nam giới) của bạn. Vui lòng nhập thông tin của người đó.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
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
