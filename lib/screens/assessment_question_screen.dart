import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/health_assessment_model.dart';
import 'assessment_result_screen.dart';

class AssessmentQuestionScreen extends StatefulWidget {
  const AssessmentQuestionScreen({super.key});

  @override
  State<AssessmentQuestionScreen> createState() => _AssessmentQuestionScreenState();
}

class _AssessmentQuestionScreenState extends State<AssessmentQuestionScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  List<AssessmentQuestionModel> _questions = [];
  bool _isLoading = true;
  String? _error;

  final Map<int, String> _answers = {};

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  
  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final questions = await _apiService.getAssessmentQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleOptionSelect(String option) {
    setState(() {
      _answers[_currentIndex] = option;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AssessmentResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_accentColor)))
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.plusJakartaSans(color: Colors.red)))
              : _questions.isEmpty
                  ? Center(child: Text("Không có câu hỏi nào", style: GoogleFonts.plusJakartaSans(color: _primaryColor)))
                  : SafeArea(
                      child: Column(
                        children: [
                          _buildHeader(),
                          Expanded(child: _buildBody()),
                          _buildBottomAction(),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildHeader() {
    final double progress = (_currentIndex + 1) / _questions.length;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: _primaryColor, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  "Đánh giá sức khỏe sinh sản",
                  style: GoogleFonts.plusJakartaSans(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu hỏi ${_currentIndex + 1} / ${_questions.length}',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  color: _primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
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
        ],
      ),
    );
  }

  Widget _buildBody() {
    final currentQuestion = _questions[_currentIndex];
    final String? selectedOption = _answers[_currentIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: _darkShadow.withOpacity(0.5), blurRadius: 16, offset: const Offset(8, 8)),
            BoxShadow(color: _lightShadow, blurRadius: 16, offset: const Offset(-8, -8)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.help_outline_rounded, color: _primaryColor, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.question,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _primaryColor,
                height: 1.4,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ...currentQuestion.options.map((option) {
              final isSelected = option == selectedOption;
              return GestureDetector(
                onTap: () => _handleOptionSelect(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: isSelected ? _accentColor.withOpacity(0.1) : _bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? _accentColor : _darkShadow.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [] : [
                      BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 8, offset: const Offset(4, 4)),
                      BoxShadow(color: _lightShadow, blurRadius: 8, offset: const Offset(-4, -4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? _accentColor : Colors.grey.shade400,
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? _primaryColor : Colors.blueGrey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    final bool hasSelection = _answers[_currentIndex] != null;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                gradient: hasSelection 
                    ? LinearGradient(
                        colors: [_primaryColor, _accentColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: hasSelection ? null : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24),
                boxShadow: hasSelection ? [
                  BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                ] : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: hasSelection ? _nextQuestion : null,
                  child: Center(
                    child: Text(
                      _currentIndex == _questions.length - 1 ? "Xem kết quả" : "Tiếp theo",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: hasSelection ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!hasSelection) ...[
            const SizedBox(height: 12),
            Text(
              "Vui lòng chọn một đáp án",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
