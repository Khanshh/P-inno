import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assessment_question_screen.dart';

class HealthAssessmentScreen extends StatelessWidget {
  const HealthAssessmentScreen({super.key});

  final Color _primaryColor = const Color(0xFF73C6D9); // Main color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // 1. Header Background
          Container(
            height: 260, // Slightly taller to be safe
            width: double.infinity,
            decoration: BoxDecoration(
              color: _primaryColor, // Unified color
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder for Moved Back button
                    const SizedBox(height: 36),
                    const SizedBox(height: 20),
                    Text(
                      "Theo Dõi Sức Khỏe",
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Đánh giá tình trạng của bạn",
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Body Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              // Remove topmost padding, use SizedBox instead
              child: Column(
                children: [
                  const SizedBox(height: 140), // Adjusted spacing to reveal header text

                  // Card 1: Intro
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Icon Container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _primaryColor, // Unified color
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryColor.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Đánh giá sức khỏe sinh sản",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Chỉ mất 5 phút để hoàn thành bảng đánh giá và nhận được báo cáo chi tiết về tình trạng sức khỏe của bạn.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card 2: Benefits
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _primaryColor.withOpacity(0.2), width: 1), // Light border
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildBenefitItem(
                            icon: Icons.analytics_outlined,
                            title: "Phân tích rủi ro",
                            subtitle: "Nhận diện sớm các nguy cơ tiềm ẩn",
                          ),
                          Divider(height: 24, thickness: 0.5, color: _primaryColor.withOpacity(0.2)),
                          _buildBenefitItem(
                            icon: Icons.local_hospital_outlined,
                            title: "Gợi ý bệnh viện",
                            subtitle: "Đề xuất địa chỉ uy tín phù hợp",
                          ),
                          Divider(height: 24, thickness: 0.5, color: _primaryColor.withOpacity(0.2)),
                          _buildBenefitItem(
                            icon: Icons.bolt_outlined,
                            title: "Kết quả tức thì",
                            subtitle: "Nhận báo cáo ngay sau khi hoàn thành",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card 3: Warning
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDE7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFF9C4), width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Color(0xFFFBC02D), size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Lưu ý: Kết quả mang tính tham khảo, không thay thế chẩn đoán của bác sĩ chuyên khoa.",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: const Color(0xFFF57F17),
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _primaryColor, // Unified color
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AssessmentQuestionScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Bắt đầu đánh giá ngay",
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // 3. Back Button (Top Layer)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1), // Unified light color
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primaryColor, size: 24), // Unified color
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
