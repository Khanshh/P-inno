import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'video_player_screen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/api_service.dart';
import '../models/discover_model.dart';

class IVFDetailScreen extends StatefulWidget {
  const IVFDetailScreen({super.key});

  @override
  State<IVFDetailScreen> createState() => _IVFDetailScreenState();
}

class _IVFDetailScreenState extends State<IVFDetailScreen> with TickerProviderStateMixin {
  int _currentTab = 0; // 0: Định nghĩa, 1: Quy trình
  final ApiService _apiService = ApiService();
  DiscoverMethodDetailModel? _detail;
  bool _isLoading = true;
  String? _error;

  late AnimationController _backgroundController;

  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _accentColor = const Color(0xFF73C6D9);
  final Color _bgColor = const Color(0xFFF8FBFF);
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6);

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadDetail();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await _apiService.getDiscoverMethodDetail('method-ivf');
      if (mounted) {
        setState(() {
          _detail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _accentColor))
              : _error != null
                  ? Center(child: Text(_error!, style: GoogleFonts.plusJakartaSans(color: Colors.red)))
                  : Column(
                      children: [
                        _buildGlassHeader(),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _currentTab == 0 ? _buildDefinitionTab() : _buildProcessTab(),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + (20 * _backgroundController.value),
              right: -150 + (30 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFE2F1AF).withOpacity(0.3)),
            ),
            Positioned(
              bottom: 100 + (30 * _backgroundController.value),
              left: -150 + (20 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD1F1F1).withOpacity(0.5)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IVF',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Thụ tinh trong ống nghiệm',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '40-50%',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabButton(0, "Định nghĩa"),
                _buildTabButton(1, "Quy trình"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final bool isActive = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: isActive ? const Color(0xFF1D4E56) : Colors.white.withOpacity(0.8),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefinitionTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      children: [
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(Icons.menu_book_rounded, 'Chi tiết phương pháp'),
              const SizedBox(height: 16),
              MarkdownBody(
                data: _detail?.content ?? 'Đang cập nhật nội dung...',
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.blueGrey.shade800, height: 1.6),
                  strong: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: _primaryColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionCard('Chỉ định điều trị', [
          'Tắc nghẽn ống dẫn trứng',
          'Lạc nội mạc tử cung',
          'Tinh trùng yếu hoặc ít',
          'Vô sinh không rõ nguyên nhân',
          'Thất bại với các phương pháp khác',
        ], Icons.assignment_turned_in_rounded, const Color(0xFFE3F2FD), const Color(0xFF1976D2)),
        const SizedBox(height: 20),
        _buildSectionCard('Ưu điểm', [
          'Tỷ lệ thành công cao',
          'Sàng lọc được các bệnh di truyền',
          'Có thể trữ phôi cho lần sau',
        ], Icons.check_circle_rounded, const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
        const SizedBox(height: 20),
        _buildSectionCard('Lưu ý', [
          'Cần tuân thủ nghiêm ngặt phác đồ điều trị',
          'Chi phí điều trị tương đối cao',
          'Có thể gặp một số tác dụng phụ của thuốc',
        ], Icons.warning_rounded, const Color(0xFFFFF3E0), const Color(0xFFF57C00)),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _accentColor, size: 22),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, List<String> items, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600,
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

  Widget _buildProcessTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      children: [
        _buildTimeline(),
        const SizedBox(height: 32),
        _buildVideoCard(),
      ],
    );
  }

  Widget _buildTimeline() {
    final List<Map<String, dynamic>> steps = [
      {'id': '1', 'title': 'Kích thích buồng trứng', 'duration': '10-12 ngày', 'desc': 'Tiêm thuốc để thu được nhiều trứng trưởng thành.'},
      {'id': '2', 'title': 'Lấy trứng', 'duration': '15-20 phút', 'desc': 'Chọc hút trứng qua ngã âm đạo dưới hướng dẫn siêu âm.'},
      {'id': '3', 'title': 'Lấy tinh trùng', 'duration': 'Cùng ngày', 'desc': 'Lấy và lọc rửa mẫu tinh trùng để chọn tinh binh tốt nhất.'},
      {'id': '4', 'title': 'Thụ tinh', 'duration': '1 ngày', 'desc': 'Trứng và tinh trùng thụ tinh trong phòng thí nghiệm.'},
      {'id': '5', 'title': 'Nuôi cấy phôi', 'duration': '3-5 ngày', 'desc': 'Phôi được nuôi cấy và theo dõi sự phát triển.'},
      {'id': '6', 'title': 'Chuyển phôi', 'duration': '15 phút', 'desc': 'Đưa phôi vào buồng tử cung của người vợ.'},
      {'id': '7', 'title': 'Xét nghiệm thai', 'duration': '14 ngày sau', 'desc': 'Xét nghiệm beta-hCG máu để xác định kết quả.'},
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: _accentColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Center(
                      child: Text(
                        step['id'],
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(width: 2, color: _accentColor.withOpacity(0.2)),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              step['title'],
                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryColor),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              step['duration'],
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _accentColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        step['desc'],
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.blueGrey.shade600, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVideoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: _accentColor.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 15))
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 20),
          Text(
            'Xem mô phỏng 3D',
            style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Trực quan hóa toàn bộ quy trình IVF',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const VideoPlayerScreen(
                      videoFileName: 'ivf_3d.mp4',
                      title: 'Video mô phỏng 3D - Quy trình IVF',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                'Bắt đầu xem ngay',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
