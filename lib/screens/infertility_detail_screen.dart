import 'package:flutter/material.dart';

class InfertilityDetailScreen extends StatelessWidget {
  const InfertilityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C6D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tìm hiểu về hiếm muộn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDefinitionSection(),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF5F7FA)),
            _buildCausesSection(),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF5F7FA)),
            _buildTreatmentsSection(),
            _buildExpertAdviceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.favorite_border, color: Color(0xFFE91E63), size: 28),
              SizedBox(width: 12),
              Text(
                'Hiếm muộn là gì?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
              children: const [
                TextSpan(text: 'Theo tổ chức Y tế Thế giới (WHO), '),
                TextSpan(
                  text: 'hiếm muộn',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' là tình trạng một cặp vợ chồng không thể thụ thai tự nhiên sau 12 tháng quan hệ tình dục đều đặn, không sử dụng biện pháp tránh thai.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC), // Hồng nhạt
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF8BBD0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info, color: Color(0xFFD81B60), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Đối với phụ nữ trên 35 tuổi, thời gian này rút ngắn còn 6 tháng. Nếu sau 6 tháng chưa có tin vui, bạn nên đi khám sớm.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.pink[900],
                      height: 1.4,
                      fontWeight: FontWeight.w500,
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

  Widget _buildCausesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFFFA000), size: 28),
              SizedBox(width: 12),
              Text(
                'Nguyên nhân hiếm muộn',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCauseCard(
            idx: 1,
            title: 'Nguyên nhân từ vợ',
            percentage: '40%',
            color: const Color(0xFFEC407A),
            items: [
              'Rối loạn phóng noãn (không rụng trứng)',
              'Tắc vòi trứng, lạc nội mạc tử cung',
              'Các vấn đề về tử cung, cổ tử cung',
              'Tuổi tác ảnh hưởng chất lượng trứng',
            ],
          ),
          const SizedBox(height: 16),
          _buildCauseCard(
            idx: 2,
            title: 'Nguyên nhân từ chồng',
            percentage: '40%',
            color: const Color(0xFF42A5F5),
            items: [
              'Số lượng/chất lượng tinh trùng kém',
              'Tắc nghẽn ống dẫn tinh',
              'Vấn đề xuất tinh, rối loạn cương dương',
              'Yếu tố di truyền hoặc bệnh lý',
            ],
          ),
          const SizedBox(height: 16),
          _buildCauseCard(
            idx: 3,
            title: 'Không rõ nguyên nhân',
            percentage: '20%',
            color: const Color(0xFFAB47BC),
            items: [
              'Cả hai vợ chồng đều bình thường',
              'Kêt hợp nguyên nhân từ cả hai phía',
              'Do yếu tố môi trường, lối sống',
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7), // Vàng nhạt
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFF59D)),
            ),
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[800],
                  height: 1.4,
                ),
                children: const [
                  TextSpan(
                    text: 'Lưu ý: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Việc xác định nguyên nhân chính xác đòi hỏi phải thăm khám chuyên sâu cho cả hai vợ chồng tại các cơ sở y tế uy tín.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseCard({
    required int idx,
    required String title,
    required String percentage,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
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
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Icon(Icons.circle,
                                  size: 6, color: Colors.grey[400]),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.medication_outlined,
                  color: Color(0xFF00ACC1), size: 28),
              SizedBox(width: 12),
              Text(
                'Phương pháp điều trị',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTreatmentItem(
            icon: Icons.personal_injury_outlined,
            color: Colors.orange,
            title: 'Thay đổi lối sống',
            subtitle: 'Dinh dưỡng, vận động, bỏ thuốc lá...',
          ),
          _buildTreatmentItem(
            icon: Icons.medical_services_outlined,
            color: Colors.blue,
            title: 'Điều trị nội khoa/ngoại khoa',
            subtitle: 'Dùng thuốc kích trứng hoặc phẫu thuật',
          ),
          _buildTreatmentItem(
            icon: Icons.science_outlined,
            color: Colors.purple,
            title: 'Hỗ trợ sinh sản (ART)',
            subtitle: 'IVF, IUI, ICSI, Đông lạnh trứng...',
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertAdviceSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3E5F5), // Tím nhạt background
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Lời khuyên từ chuyên gia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8E24AA),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Đừng ngần ngại tìm kiếm sự giúp đỡ. Y học hiện đại có rất nhiều phương pháp để hỗ trợ bạn hiện thực hóa giấc mơ làm cha mẹ. Việc phát hiện và điều trị sớm là chìa khóa thành công.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73C6D9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Tham khảo bệnh viện/phòng khám',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
