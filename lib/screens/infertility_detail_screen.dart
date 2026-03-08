import 'package:flutter/material.dart';

class InfertilityDetailScreen extends StatelessWidget {
  const InfertilityDetailScreen({super.key});

  static const Color _primaryColor = Color(0xFF73C6D9);
  static const Color _primaryLight = Color(0xFFE0F4F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // ── Gradient Header ──
          _buildHeader(context),
          // ── Scrollable Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section 1: Hiếm muộn là gì? ──
                  _buildSectionHeader(Icons.favorite, 'Hiếm muộn là gì?'),
                  const SizedBox(height: 14),
                  _buildDefinitionCard(),
                  const SizedBox(height: 28),

                  // ── Section 2: Nguyên nhân hiếm muộn ──
                  _buildSectionHeader(
                      Icons.warning_amber_rounded, 'Nguyên nhân hiếm muộn'),
                  const SizedBox(height: 14),
                  _buildCauseCard(
                    title: 'Nguyên nhân từ phụ nữ',
                    percentage: '40%',
                    items: const [
                      'Rối loạn phóng noãn',
                      'Tắc nghẽn vòi trứng',
                      'Lạc nội mạc tử cung',
                      'Rối loạn tử cung',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCauseCard(
                    title: 'Nguyên nhân từ nam giới',
                    percentage: '40%',
                    items: const [
                      'Số lượng tinh trùng thấp',
                      'Chất lượng tinh trùng kém',
                      'Rối loạn cương dương',
                      'Tắc nghẽn ống dẫn tinh',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCauseCard(
                    title: 'Nguyên nhân không rõ',
                    percentage: '20%',
                    items: const [
                      'Không xác định được nguyên nhân cụ thể',
                      'Yếu tố miễn dịch',
                      'Yếu tố tâm lý, căng thẳng',
                      'Các yếu tố môi trường',
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildWarningBox(),
                  const SizedBox(height: 28),

                  // ── Section 3: Phương pháp điều trị ──
                  _buildSectionHeader(
                      Icons.medical_services_outlined, 'Phương pháp điều trị'),
                  const SizedBox(height: 14),
                  _buildTreatmentItem(
                    icon: Icons.medication_outlined,
                    title: 'Điều trị thuốc',
                    subtitle: 'Sử dụng thuốc kích thích rụng trứng hoặc điều chỉnh nội tiết',
                  ),
                  _buildTreatmentItem(
                    icon: Icons.healing_outlined,
                    title: 'Phẫu thuật',
                    subtitle:
                        'Can thiệp phẫu thuật/khắc phục tắc nghẽn hoặc bất thường cấu trúc',
                  ),
                  _buildTreatmentItem(
                    icon: Icons.biotech_outlined,
                    title: 'Hỗ trợ sinh sản',
                    subtitle:
                        'IVF, IUI, ICSI và các kỹ thuật hỗ trợ sinh sản hiện đại',
                  ),
                  _buildTreatmentItem(
                    icon: Icons.self_improvement_outlined,
                    title: 'Thay đổi lối sống',
                    subtitle:
                        'Chế độ ăn uống, tập luyện và giảm căng thẳng',
                  ),
                  const SizedBox(height: 24),

                  // ── Section 4: Lời khuyên ──
                  _buildExpertAdviceCard(),
                  const SizedBox(height: 16),
                  _buildActionButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Header – Gradient style giống ảnh
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12,
        right: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF5BB8CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Text(
            'Tìm hiểu về hiếm muộn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Section Header – Icon + Title (giống ảnh)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSectionHeader(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: _primaryColor, size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Section 1: Định nghĩa Card
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDefinitionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text: 'Hiếm muộn ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextSpan(
                  text:
                      'là tình trạng một cặp vợ chồng không thể mang thai sau 12 tháng quan hệ tình dục thường xuyên (2-3 lần/ tuần) mà không sử dụng bất kỳ biện pháp tránh thai nào.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Highlight box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: _primaryColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Đối với phụ nữ trên 35 tuổi, thời gian này được rút ngắn xuống còn 6 tháng.',
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Section 2: Cause Card
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCauseCard({
    required String title,
    required String percentage,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with percentage badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Bullet list
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.3,
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

  // ═══════════════════════════════════════════════════════════════
  //  Warning / Lưu ý Box
  // ═══════════════════════════════════════════════════════════════
  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.error_outline, color: Color(0xFFFFA000), size: 18),
              SizedBox(width: 8),
              Text(
                'Lưu ý:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Trong một số trường hợp, hiếm muộn có thể do sự kết hợp nguyên nhân từ cả vợ và chồng. Việc thăm khám và xét nghiệm kỹ lưỡng là rất quan trọng để xác định nguyên nhân chính xác.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.orange[900],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Section 3: Treatment Item
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTreatmentItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Section 4: Expert Advice Card
  // ═══════════════════════════════════════════════════════════════
  Widget _buildExpertAdviceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            'Lời khuyên từ chuyên gia',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Một cặp vợ chồng có thể cải thiện tình trạng và tăng cơ hội mang thai bằng cách đi khám tại các cơ sở y tế chuyên khoa, thăm khám toàn diện và tư vấn chuyên khoa để có phương pháp điều trị phù hợp.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  Action Button
  // ═══════════════════════════════════════════════════════════════
  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to hospital/clinic list
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.local_hospital_outlined, color: Colors.white,
            size: 20),
        label: const Text(
          'Tham khảo bệnh viện/ phòng khám',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
