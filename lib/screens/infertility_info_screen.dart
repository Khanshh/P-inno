import 'package:flutter/material.dart';

class InfertilityInfoScreen extends StatelessWidget {
  const InfertilityInfoScreen({super.key});

  final Color _primaryColor = const Color(0xFF73C6D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tìm hiểu về hiếm muộn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Hiếm muộn là gì?
            _buildSectionTitle(Icons.favorite, 'Hiếm muộn là gì?'),
            const SizedBox(height: 12),
            const Text(
              'Hiếm muộn là tình trạng một cặp vợ chồng không thể thụ thai sau ít nhất một năm quan hệ tình dục thường xuyên mà không sử dụng các biện pháp tránh thai.',
              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),
            _buildHighlightBox(
              'Đối với phụ nữ trên 35 tuổi, thời gian này được rút ngắn xuống còn 6 tháng.',
            ),
            const SizedBox(height: 32),

            // Section 2: Nguyên nhân hiếm muộn
            _buildSectionTitle(Icons.warning_amber_rounded, 'Nguyên nhân hiếm muộn'),
            const SizedBox(height: 16),
            _buildCauseCard(
              title: 'Nguyên nhân từ phụ nữ',
              percentage: '40%',
              causes: [
                'Rối loạn rụng trứng',
                'Tắc ống dẫn trứng',
                'Lạc nội mạc tử cung',
                'Hội chứng buồng trứng đa nang (PCOS)',
              ],
            ),
            const SizedBox(height: 16),
            _buildCauseCard(
              title: 'Nguyên nhân từ nam giới',
              percentage: '40%',
              causes: [
                'Chất lượng tinh trùng kém',
                'Rối loạn xuất tinh',
                'Giãn tĩnh mạch thừng tinh',
                'Yếu tố di truyền',
              ],
            ),
            const SizedBox(height: 16),
            _buildCauseCard(
              title: 'Nguyên nhân không rõ',
              percentage: '20%',
              causes: [
                'Do cả hai vợ chồng',
                'Yếu tố môi trường và tâm lý',
                'Chưa rõ nguyên nhân y khoa',
              ],
            ),
            const SizedBox(height: 16),
            _buildWarningBox(
              'Trong một số trường hợp, hiếm muộn có thể do sự kết hợp của nhiều yếu tố từ cả vợ và chồng.',
            ),
            const SizedBox(height: 32),

            // Section 3: Phương pháp điều trị
            _buildSectionTitle(Icons.medical_services_outlined, 'Phương pháp điều trị'),
            const SizedBox(height: 16),
            _buildTreatmentMethodCard(
              icon: Icons.medication_outlined,
              title: 'Điều trị bằng thuốc',
              subtitle: 'Kích thích rụng trứng, điều trị nội tiết',
            ),
            const SizedBox(height: 12),
            _buildTreatmentMethodCard(
              icon: Icons.settings_backup_restore_outlined,
              title: 'Phẫu thuật',
              subtitle: 'Thông vòi trứng, nội soi tử cung',
            ),
            const SizedBox(height: 12),
            _buildTreatmentMethodCard(
              icon: Icons.biotech_outlined,
              title: 'Hỗ trợ sinh sản (ART)',
              subtitle: 'IUI (Bơm tinh trùng), IVF (Thụ tinh trong ống nghiệm)',
            ),
            const SizedBox(height: 12),
            _buildTreatmentMethodCard(
              icon: Icons.spa_outlined,
              title: 'Thay đổi lối sống',
              subtitle: 'Chế độ dinh dưỡng, giảm căng thẳng',
            ),
            const SizedBox(height: 32),

            // Section 4: Footer
            _buildFooterCard(),
            const SizedBox(height: 24),
            _buildActionButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: _primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA), // Light Blue
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: _primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseCard({
    required String title,
    required String percentage,
    required List<String> causes,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...causes.map((cause) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cause,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWarningBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light Orange/Yellow
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE65100),
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildTreatmentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildFooterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Lời khuyên từ chuyên gia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đừng quá lo lắng, y học hiện đại có nhiều giải pháp hỗ trợ. Hãy đi khám sớm để được tư vấn chính xác nhất.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.location_on_outlined, color: Colors.white),
        label: const Text(
          'THAM KHẢO PHÒNG KHÁM',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
