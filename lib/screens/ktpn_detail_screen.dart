import 'package:flutter/material.dart';

class KTPNDetailScreen extends StatefulWidget {
  const KTPNDetailScreen({super.key});

  @override
  State<KTPNDetailScreen> createState() => _KTPNDetailScreenState();
}

class _KTPNDetailScreenState extends State<KTPNDetailScreen> {
  int _selectedTabIndex = 0; // Fix: Khai báo biến state quản lý tab
  final Color _emeralColor = const Color(0xFF73C6D9);
  final Color _backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _selectedTabIndex == 0 
                ? _buildDefinitionTab() 
                : _buildProcessTab(),
          ),
        ],
      ),
    );
  }

  // ── Header Section ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _emeralColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 12,
        right: 16,
        bottom: 20,
      ),
      child: Column(
        children: [
          // AppBar Row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Kích thích phóng noãn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '~ 20-30%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom TabBar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildTabButton(0, "Định nghĩa", Icons.book),
                _buildTabButton(1, "Quy trình điều trị", Icons.sync),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? const Color(0xFF0277BD) : Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? const Color(0xFF0277BD) : Colors.white.withOpacity(0.8),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Definition Tab Content ──
  Widget _buildDefinitionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDefinitionCard(),
          const SizedBox(height: 16),
          _buildIndicationsCard(),
          const SizedBox(height: 16),
          _buildAdvantagesCard(),
          const SizedBox(height: 16),
          _buildNotesCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Card 1: Định nghĩa
  Widget _buildDefinitionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF73C6D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.book, color: Color(0xFF73C6D9), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Định nghĩa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Kích thích phóng noãn là phương pháp sử dụng thuốc để kích thích buồng trứng sản xuất và giải phóng trứng. Đây thường là bước điều trị đầu tiên cho những phụ nữ có vấn đề về rụng trứng.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Card 2: Chỉ định điều trị
  Widget _buildIndicationsCard() {
    final List<String> indications = [
      "Rối loạn phóng noãn",
      "Hội chứng buồng trứng đa nang (PCOS)",
      "Chu kỳ kinh không đều hoặc vô kinh",
      "Buồng trứng không tạo trứng tự nhiên",
      "Chuẩn bị cho IUI hoặc quan hệ có kế hoạch"
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chỉ định điều trị',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...indications.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF73C6D9), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0277BD),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // Card 3: Ưu điểm
  Widget _buildAdvantagesCard() {
    final List<String> advantages = [
      "Phương pháp đơn giản, ít xâm lấn",
      "Chi phí thấp nhất",
      "Có thể kết hợp với quan hệ tự nhiên",
      "Tác dụng phụ ít, dễ thực hiện"
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF73C6D9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF73C6D9), size: 22),
              SizedBox(width: 8),
              const Text(
                'Ưu điểm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF73C6D9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...advantages.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF73C6D9), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0277BD),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // Card 4: Lưu ý
  Widget _buildNotesCard() {
    final List<String> notes = [
      "Tỷ lệ thành công thấp hơn các phương pháp khác",
      "Nguy cơ đa thai cao hơn",
      "Nguy cơ hội chứng quá kích buồng trứng",
      "Cần theo dõi sát để tránh biến chứng"
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.error_outline, color: Color(0xFFF57C00), size: 22),
              SizedBox(width: 8),
              const Text(
                'Lưu ý',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...notes.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFF57C00), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBF360C),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Process Tab Content ──
  Widget _buildProcessTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimelineStep(
            step: 1,
            totalSteps: 7,
            title: "Thăm khám & Xét nghiệm",
            duration: "Ngày 2 chu kỳ",
            description: "Bác sĩ thực hiện siêu âm đầu dò và xét nghiệm nội tiết để đánh giá tình trạng buồng trứng trước khi bắt đầu.",
            progress: 0.15,
          ),
          _buildTimelineStep(
            step: 2,
            totalSteps: 7,
            title: "Sử dụng thuốc kích trứng",
            duration: "Ngày 2 - Ngày 6",
            description: "Dùng thuốc uống hoặc tiêm liên tục theo chỉ định của bác sĩ để kích thích các nang noãn phát triển.",
            progress: 0.30,
          ),
          _buildTimelineStep(
            step: 3,
            totalSteps: 7,
            title: "Siêu âm theo dõi nang noãn",
            duration: "Ngày 8 - Ngày 12",
            description: "Thực hiện siêu âm định kỳ để theo dõi sự phát triển của trứng và độ dày nội mạc tử cung.",
            progress: 0.45,
          ),
          _buildTimelineStep(
            step: 4,
            totalSteps: 7,
            title: "Tiêm thuốc rụng trứng (hCG)",
            duration: "1 lần tiêm",
            description: "Khi nang noãn đạt kích thước mục tiêu, bác sĩ sẽ chỉ định tiêm thuốc để trứng trưởng thành hoàn toàn.",
            progress: 0.60,
          ),
          _buildTimelineStep(
            step: 5,
            totalSteps: 7,
            title: "Giao hợp hoặc IUI",
            duration: "Sau 36 giờ tiêm",
            description: "Cặp đôi thực hiện giao hợp tự nhiên hoặc bác sĩ tiến hành bơm tinh trùng vào tử cung (IUI) để tăng tỷ lệ thụ thai.",
            progress: 0.75,
          ),
          _buildTimelineStep(
            step: 6,
            totalSteps: 7,
            title: "Hỗ trợ hoàng thể",
            duration: "Trong 14 ngày",
            description: "Sử dụng thuốc nội tiết (Progesterone) để hỗ trợ niêm mạc tử cung, tạo điều kiện tốt nhất cho phôi làm tổ.",
            progress: 0.90,
          ),
          _buildTimelineStep(
            step: 7,
            totalSteps: 7,
            title: "Xét nghiệm thử thai",
            duration: "14 ngày sau",
            description: "Sau 2 tuần, bạn thực hiện xét nghiệm máu hoặc dùng que thử thai để xác định kết quả thụ thai.",
            progress: 1.0,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required int step,
    required int totalSteps,
    required String title,
    required String duration,
    required String description,
    required double progress,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Trục thời gian bên trái
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF73C6D9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3), // Viền trắng bo ngoài
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF73C6D9).withOpacity(0.3), blurRadius: 4),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      step.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFF73C6D9).withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          
          // Khối Card nội dung bên phải
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Bắt buộc căn trái toàn bộ
                  children: [
                    // Dòng 1: Tiêu đề và Số thứ tự bước (VD: 1/7)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        Text(
                          "$step/$totalSteps",
                          style: const TextStyle(color: Color(0xFF73C6D9), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Dòng 2: Tag thời gian nằm ĐỘC LẬP bên trái dưới tiêu đề
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73C6D9),
                        borderRadius: BorderRadius.circular(20), // Bo tròn giống viên thuốc
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Vừa đủ chiều rộng text
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Dòng 3: Mô tả
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    
                    // Dòng 4: Thanh Tiến trình
                    Row(
                      children: [
                        const Text("Tiến trình", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const Spacer(),
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6, // Làm thanh line dày lên 1 chút
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF73C6D9)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
