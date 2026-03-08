import 'package:flutter/material.dart';
import 'assessment_result_screen.dart';

class AssessmentFormScreen extends StatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  State<AssessmentFormScreen> createState() => _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends State<AssessmentFormScreen> {
  static const Color _primaryColor = Color(0xFF73C6D9);
  static const Color _bgColor = Color(0xFFF5F7FA);

  int _currentStep = 0;
  final int _totalSteps = 5;

  // ── Step 1 state ──
  final TextEditingController _birthYearCtrl = TextEditingController();
  int _maritalStatus = -1; // 0=Độc thân, 1=Hẹn hò, 2=Kết hôn
  int _planChild = -1; // 0=Có, 1=Không

  // ── Step 2 state ──
  int _cycleRegularity = -1;
  int _cycleLength = -1;
  int _painLevel = -1;
  int _abnormalBleeding = -1;

  // ── Step 3 state ──
  final Map<int, bool> _symptoms = {0: false, 1: false, 2: false, 3: false, 4: false};
  final Map<int, int> _symptomSeverity = {};
  final Map<int, int> _symptomFrequency = {};

  // ── Step 4 state ──
  final Map<int, bool> _lifestyle = {0: false, 1: false, 2: false, 3: false, 4: false};

  // ── Step 5 state ──
  final Map<int, bool> _history = {0: false, 1: false, 2: false, 3: false};

  bool _isLoading = false;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AssessmentResultScreen()),
    );
  }

  @override
  void dispose() {
    _birthYearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: _prevStep,
        ),
        title: Column(
          children: [
            const Text(
              'Hồ sơ sức khỏe sinh sản',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Bước ${_currentStep + 1}/$_totalSteps',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? _buildLoadingView()
          : Column(
              children: [
                _buildProgressDots(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: _buildStepContent(),
                  ),
                ),
                _buildFooterButton(),
              ],
            ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // Loading View
  // ════════════════════════════════════════════════════════════
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: const AlwaysStoppedAnimation<Color>(_primaryColor),
              backgroundColor: _primaryColor.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Đang phân tích dữ liệu...',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng đợi trong giây lát',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // Progress Dots
  // ════════════════════════════════════════════════════════════
  Widget _buildProgressDots() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          final isActive = index == _currentStep;
          final isDone = index < _currentStep;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isActive ? 28 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive
                  ? _primaryColor
                  : isDone
                      ? _primaryColor.withOpacity(0.4)
                      : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // Footer Button
  // ════════════════════════════════════════════════════════════
  Widget _buildFooterButton() {
    final isLast = _currentStep == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLast ? 'Xem kết quả đánh giá' : 'Tiếp theo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!isLast) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // Step Router
  // ════════════════════════════════════════════════════════════
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      default:
        return const SizedBox.shrink();
    }
  }

  // ════════════════════════════════════════════════════════════
  // STEP 1: Thông tin nền
  // ════════════════════════════════════════════════════════════
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(Icons.person_outline, 'Thông tin nền'),
        const SizedBox(height: 24),

        // Năm sinh
        _buildLabel('Năm sinh'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _birthYearCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'VD: 1995',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Tình trạng hôn nhân
        _buildLabel('Tình trạng hôn nhân'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildChoiceButton('Độc thân', 0, _maritalStatus, (v) => setState(() => _maritalStatus = v)),
            const SizedBox(width: 10),
            _buildChoiceButton('Đang hẹn hò', 1, _maritalStatus, (v) => setState(() => _maritalStatus = v)),
            const SizedBox(width: 10),
            _buildChoiceButton('Đã kết hôn', 2, _maritalStatus, (v) => setState(() => _maritalStatus = v)),
          ],
        ),
        const SizedBox(height: 24),

        // Kế hoạch sinh con
        _buildLabel('Có kế hoạch sinh con trong 1-2 năm không?'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildYesNoButton('Có', Icons.check_circle_outline, const Color(0xFF43A047), 0, _planChild, (v) => setState(() => _planChild = v)),
            const SizedBox(width: 12),
            _buildYesNoButton('Không', Icons.cancel_outlined, const Color(0xFFE53935), 1, _planChild, (v) => setState(() => _planChild = v)),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // STEP 2: Chu kỳ & Sinh lý
  // ════════════════════════════════════════════════════════════
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(Icons.favorite_outline, 'Module A - Chu kỳ & sinh lý'),
        const SizedBox(height: 24),

        // Độ đều
        _buildLabel('Độ đều của chu kỳ'),
        const SizedBox(height: 10),
        _buildVerticalChoices(
          ['Đều đặn (28 ± 3 ngày)', 'Hơi không đều (±7 ngày)', 'Không đều (biến động lớn)'],
          _cycleRegularity,
          (v) => setState(() => _cycleRegularity = v),
        ),
        const SizedBox(height: 24),

        // Độ dài
        _buildLabel('Độ dài chu kỳ trung bình'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildChoiceButton('< 21 ngày', 0, _cycleLength, (v) => setState(() => _cycleLength = v)),
            const SizedBox(width: 10),
            _buildChoiceButton('21-35 ngày', 1, _cycleLength, (v) => setState(() => _cycleLength = v)),
            const SizedBox(width: 10),
            _buildChoiceButton('> 35 ngày', 2, _cycleLength, (v) => setState(() => _cycleLength = v)),
          ],
        ),
        const SizedBox(height: 24),

        // Đau bụng kinh
        _buildLabel('Mức độ đau bụng kinh'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final isSelected = _painLevel == index;
            return GestureDetector(
              onTap: () => setState(() => _painLevel = index),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? _primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? _primaryColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Không đau', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text('Rất đau', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Ra máu bất thường
        _buildLabel('Ra máu bất thường / Trễ kinh'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildYesNoButton('Có', Icons.check_circle_outline, const Color(0xFFFB8C00), 0, _abnormalBleeding, (v) => setState(() => _abnormalBleeding = v)),
            const SizedBox(width: 12),
            _buildYesNoButton('Không', Icons.cancel_outlined, Colors.grey, 1, _abnormalBleeding, (v) => setState(() => _abnormalBleeding = v)),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // STEP 3: Triệu chứng nghi ngờ
  // ════════════════════════════════════════════════════════════
  Widget _buildStep3() {
    final symptomNames = [
      'Đau vùng chậu',
      'Khí hư bất thường',
      'Mệt mỏi kéo dài',
      'Rối loạn hormone',
      'Giảm ham muốn',
    ];
    final symptomIcons = [
      Icons.accessibility_new,
      Icons.water_drop_outlined,
      Icons.battery_alert_outlined,
      Icons.sync_problem_outlined,
      Icons.trending_down,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(Icons.monitor_heart_outlined, 'Module B - Triệu chứng nghi ngờ'),
        const SizedBox(height: 8),
        Text(
          'Chọn các triệu chứng bạn gặp phải, sau đó đánh giá mức độ.',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 20),
        ...List.generate(symptomNames.length, (index) {
          final isChecked = _symptoms[index] ?? false;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isChecked ? _primaryColor : Colors.grey.shade300,
                width: isChecked ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _symptoms[index] = !isChecked;
                      if (!_symptoms[index]!) {
                        _symptomSeverity.remove(index);
                        _symptomFrequency.remove(index);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isChecked ? _primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            symptomIcons[index],
                            color: isChecked ? _primaryColor : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            symptomNames[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isChecked ? Colors.black87 : Colors.grey[700],
                            ),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isChecked ? _primaryColor : Colors.transparent,
                            border: Border.all(
                              color: isChecked ? _primaryColor : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isChecked
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                // Expansion when checked
                if (isChecked) ...[
                  Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mức độ:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildMiniChoice('Nhẹ', 0, _symptomSeverity[index] ?? -1, (v) => setState(() => _symptomSeverity[index] = v)),
                            const SizedBox(width: 8),
                            _buildMiniChoice('Vừa', 1, _symptomSeverity[index] ?? -1, (v) => setState(() => _symptomSeverity[index] = v)),
                            const SizedBox(width: 8),
                            _buildMiniChoice('Nặng', 2, _symptomSeverity[index] ?? -1, (v) => setState(() => _symptomSeverity[index] = v)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text('Tần suất:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildMiniChoice('Thỉnh thoảng', 0, _symptomFrequency[index] ?? -1, (v) => setState(() => _symptomFrequency[index] = v)),
                            const SizedBox(width: 8),
                            _buildMiniChoice('Thường xuyên', 1, _symptomFrequency[index] ?? -1, (v) => setState(() => _symptomFrequency[index] = v)),
                            const SizedBox(width: 8),
                            _buildMiniChoice('Liên tục', 2, _symptomFrequency[index] ?? -1, (v) => setState(() => _symptomFrequency[index] = v)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // STEP 4: Lối sống
  // ════════════════════════════════════════════════════════════
  Widget _buildStep4() {
    final items = [
      {'title': 'Ngủ dưới 6 tiếng', 'sub': 'Thiếu ngủ kéo dài ảnh hưởng đến hormone sinh sản', 'icon': Icons.bedtime_outlined},
      {'title': 'Stress kéo dài', 'sub': 'Căng thẳng tâm lý làm rối loạn chu kỳ kinh nguyệt', 'icon': Icons.psychology_outlined},
      {'title': 'Vận động ít', 'sub': 'Ít hơn 150 phút/tuần hoạt động thể chất', 'icon': Icons.directions_walk_outlined},
      {'title': 'BMI bất thường', 'sub': 'BMI <18.5 hoặc >25 ảnh hưởng đến khả năng thụ thai', 'icon': Icons.monitor_weight_outlined},
      {'title': 'Hút thuốc / Rượu bia', 'sub': 'Sử dụng chất kích thích thường xuyên', 'icon': Icons.smoke_free_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(Icons.nights_stay_outlined, 'Module C - Lối sống'),
        const SizedBox(height: 8),
        Text(
          'Chọn tất cả các yếu tố phù hợp với bạn.',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 20),
        ...List.generate(items.length, (index) {
          final isChecked = _lifestyle[index] ?? false;
          return GestureDetector(
            onTap: () => setState(() => _lifestyle[index] = !isChecked),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isChecked ? _primaryColor.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isChecked ? _primaryColor : Colors.grey.shade300,
                  width: isChecked ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isChecked ? _primaryColor.withOpacity(0.12) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      items[index]['icon'] as IconData,
                      color: isChecked ? _primaryColor : Colors.grey[600],
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index]['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isChecked ? Colors.black87 : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]['sub'] as String,
                          style: TextStyle(fontSize: 12.5, color: Colors.grey[500], height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? _primaryColor : Colors.transparent,
                      border: Border.all(
                        color: isChecked ? _primaryColor : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // STEP 5: Tiền sử
  // ════════════════════════════════════════════════════════════
  Widget _buildStep5() {
    final items = [
      {'title': 'Rối loạn nội tiết', 'sub': 'PCOS, suy giáp, cường giáp, v.v.', 'icon': Icons.sync_outlined},
      {'title': 'Viêm nhiễm phụ khoa', 'sub': 'Viêm vùng chậu, viêm âm đạo tái phát', 'icon': Icons.healing_outlined},
      {'title': 'Từng điều trị hormone', 'sub': 'Sử dụng thuốc tránh thai kéo dài, điều trị nội tiết', 'icon': Icons.medication_outlined},
      {'title': 'Gia đình có tiền sử', 'sub': 'Người thân từng gặp vấn đề vô sinh, lạc nội mạc tử cung', 'icon': Icons.family_restroom_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(Icons.history, 'Module D - Tiền sử'),
        const SizedBox(height: 8),
        Text(
          'Chọn các yếu tố tiền sử phù hợp với bạn.',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 20),
        ...List.generate(items.length, (index) {
          final isChecked = _history[index] ?? false;
          return GestureDetector(
            onTap: () => setState(() => _history[index] = !isChecked),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isChecked ? _primaryColor.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isChecked ? _primaryColor : Colors.grey.shade300,
                  width: isChecked ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isChecked ? _primaryColor.withOpacity(0.12) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      items[index]['icon'] as IconData,
                      color: isChecked ? _primaryColor : Colors.grey[600],
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index]['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isChecked ? Colors.black87 : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]['sub'] as String,
                          style: TextStyle(fontSize: 12.5, color: Colors.grey[500], height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? _primaryColor : Colors.transparent,
                      border: Border.all(
                        color: isChecked ? _primaryColor : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),

        // Warning Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.push_pin, color: Color(0xFFE53935), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tiền sử bệnh được gán trọng số cao trong tính toán nguy cơ. Hãy khai báo chính xác để nhận kết quả đánh giá phù hợp nhất.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade800,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // Shared Widgets
  // ════════════════════════════════════════════════════════════

  Widget _buildStepHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primaryColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildChoiceButton(String label, int value, int groupValue, ValueChanged<int> onTap) {
    final isSelected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? _primaryColor : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYesNoButton(String label, IconData icon, Color iconColor, int value, int groupValue, ValueChanged<int> onTap) {
    final isSelected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? _primaryColor : iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? _primaryColor : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalChoices(List<String> options, int groupValue, ValueChanged<int> onTap) {
    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = index == groupValue;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor.withOpacity(0.08) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? _primaryColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? _primaryColor : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? _primaryColor : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMiniChoice(String label, int value, int groupValue, ValueChanged<int> onTap) {
    final isSelected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? _primaryColor : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
