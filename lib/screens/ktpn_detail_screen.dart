import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KTPNDetailScreen extends StatefulWidget {
  const KTPNDetailScreen({super.key});

  @override
  State<KTPNDetailScreen> createState() => _KTPNDetailScreenState();
}

class _KTPNDetailScreenState extends State<KTPNDetailScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  
  late AnimationController _backgroundController;

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
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
            children: [
              _buildGlassHeader(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _selectedTabIndex == 0 ? _buildDefinitionTab() : _buildProcessTab(),
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
              top: 50 + (30 * _backgroundController.value),
              right: -50 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFE2F1AF).withOpacity(0.3)),
            ),
            Positioned(
              bottom: 100 + (30 * _backgroundController.value),
              left: -100 + (20 * _backgroundController.value),
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
          BoxShadow(color: _primaryColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kích thích phóng noãn',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        '~ 25%',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
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
    final bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : [],
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
              _buildSectionTitle(Icons.book_rounded, 'Định nghĩa'),
              const SizedBox(height: 16),
              Text(
                'Kích thích phóng noãn là phương pháp sử dụng thuốc để kích thích buồng trứng sản xuất và giải phóng trứng. Đây thường là bước điều trị đầu tiên cho những phụ nữ có vấn đề về rụng trứng.',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.blueGrey.shade800, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionCard('Chỉ định điều trị', [
          "Rối loạn phóng noãn",
          "Hội chứng buồng trứng đa nang (PCOS)",
          "Chu kỳ kinh không đều hoặc vô kinh",
          "Buồng trứng không tạo trứng tự nhiên",
          "Chuẩn bị cho IUI hoặc quan hệ có kế hoạch"
        ], Icons.assignment_turned_in_rounded, const Color(0xFFE3F2FD), const Color(0xFF1976D2)),
        const SizedBox(height: 20),
        _buildSectionCard('Ưu điểm', [
          "Phương pháp đơn giản, ít xâm lấn",
          "Chi phí thấp nhất",
          "Có thể kết hợp quan hệ tự nhiên",
          "Ít tác dụng phụ, dễ thực hiện"
        ], Icons.check_circle_rounded, const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
        const SizedBox(height: 20),
        _buildSectionCard('Lưu ý', [
          "Tỷ lệ thành công thấp hơn các phương pháp khác",
          "Nguy cơ đa thai cao hơn",
          "Nguy cơ quá kích buồng trứng",
          "Cần theo dõi sát để tránh biến chứng"
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
        boxShadow: [BoxShadow(color: _darkShadow.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Padding(padding: const EdgeInsets.all(24), child: child)),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _accentColor.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: _accentColor, size: 22)),
        const SizedBox(width: 14),
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 19, fontWeight: FontWeight.w800, color: _primaryColor)),
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
        boxShadow: [BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: iconColor, size: 24), const SizedBox(width: 12), Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _primaryColor))]),
          const SizedBox(height: 18),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.all(4.0), child: Container(width: 6, height: 6, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item, style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w600, height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildProcessTab() {
    final List<Map<String, dynamic>> steps = [
      {'id': '1', 'title': "Thăm khám & Xét nghiệm", 'duration': "Ngày 2 chu kỳ", 'desc': "Siêu âm đầu dò và xét nghiệm nội tiết đánh giá buồng trứng."},
      {'id': '2', 'title': "Sử dụng thuốc kích trứng", 'duration': "Ngày 2 - Ngày 6", 'desc': "Dùng thuốc uống hoặc tiêm kích thích nang noãn phát triển."},
      {'id': '3', 'title': "Siêu âm theo dõi", 'duration': "Ngày 8 - Ngày 12", 'desc': "Theo dõi sự phát triển trứng và độ dày nội mạc tử cung."},
      {'id': '4', 'title': "Tiêm thuốc rụng trứng", 'duration': "1 lần tiêm", 'desc': "Tiêm thuốc hCG để trứng trưởng thành hoàn toàn."},
      {'id': '5', 'title': "Giao hợp hoặc IUI", 'duration': "Sau 36 giờ tiêm", 'desc': "Giao hợp tự nhiên hoặc bơm IUI tăng tỷ lệ thụ thai."},
      {'id': '6', 'title': "Hỗ trợ hoàng thể", 'duration': "Trong 14 ngày", 'desc': "Sử dụng Progesterone hỗ trợ niêm mạc phôi làm tổ."},
      {'id': '7', 'title': "Xét nghiệm thử thai", 'duration': "14 ngày sau", 'desc': "Kiểm tra xét nghiệm máu để xác định kết quả thụ thai."},
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        return IntrinsicHeight(
          child: Row(children: [
            Column(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: _accentColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: _accentColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]), child: Center(child: Text(step['id'], style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)))),
              if (index != steps.length - 1) Expanded(child: Container(width: 2, color: _accentColor.withOpacity(0.2))),
            ]),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: _darkShadow.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(step['title'], style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryColor))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(step['duration'], style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _accentColor)))]),
                    const SizedBox(height: 10),
                    Text(step['desc'], style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.blueGrey.shade600, height: 1.5)),
                  ],
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
