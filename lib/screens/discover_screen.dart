import 'package:flutter/material.dart';
import 'infertility_detail_screen.dart';
import 'ivf_detail_screen.dart';
import 'icsi_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerCard(context),
                  const SizedBox(height: 25),
                  const Text(
                    'Phương pháp hỗ trợ sinh sản',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Các giải pháp y học hiện đại giúp tăng tỷ lệ thụ thai',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildGridOptions(),
                  const SizedBox(height: 25),
                  _buildConsultationCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF73C6D9),
      padding: const EdgeInsets.only(
        top: 60,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Tìm Hiểu',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kiến thức về hiếm muộn và các phương pháp hỗ trợ sinh sản',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF73C6D9), // Xanh chủ đạo
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF73C6D9).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const InfertilityDetailScreen(),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Tìm hiểu về hiếm muộn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridOptions() {
    final List<Map<String, dynamic>> methods = [
      {
        'title': 'IVF',
        'subtitle': 'Thụ tinh trong ống nghiệm',
        'icon': Icons.science_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'IUI',
        'subtitle': 'Bơm tinh trùng vào tử cung',
        'icon': Icons.medical_services_outlined,
        'color': Colors.teal,
      },
      {
        'title': 'ICSI',
        'subtitle': 'Tiêm tinh trùng vào bào tương',
        'icon': Icons.biotech_outlined,
        'color': Colors.purple,
      },
      {
        'title': 'Đông trứng',
        'subtitle': 'Bảo tồn khả năng sinh sản',
        'icon': Icons.ac_unit_outlined,
        'color': Colors.cyan,
      },
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: methods.map((method) => _buildOptionCard(method)).toList(),
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> method) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate width for 2 columns with spacing
        // Screen width - padding (40) - spacing (16) / 2
        final double itemWidth = (MediaQuery.of(context).size.width - 40 - 16) / 2;
        
        return Container(
          width: itemWidth,
          padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (method['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  method['icon'] as IconData,
                  color: method['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                method['title'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                method['subtitle'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                   if (method['title'] == 'IVF') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const IVFDetailScreen(),
                      ),
                    );
                  } else if (method['title'] == 'ICSI') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ICSIDetailScreen(),
                      ),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Tìm hiểu thêm',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsultationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: Color(0xFF73C6D9),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Cần tư vấn trực tiếp?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Liên hệ với bác sĩ chuyên khoa để được giải đáp',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73C6D9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tham khảo ngay',
                style: TextStyle(
                  fontSize: 15,
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
