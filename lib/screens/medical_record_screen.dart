import 'package:flutter/material.dart';

class MedicalRecordScreen extends StatelessWidget {
  const MedicalRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildBody(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
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
              child: SafeArea(
                top: false,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, color: Color(0xFF73C6D9)),
                  label: const Text('Tải xuống hồ sơ (PDF)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF73C6D9),
                    side: const BorderSide(color: Color(0xFF73C6D9)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4DADC2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bệnh viện Phụ Sản Trung ương',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cổng thông tin bệnh nhân',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                    label: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            // User Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026024d'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nguyễn Thị Lan Anh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Mã BN: 198203',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'NS: 12/05/1995',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab Bar UI (Visual only)
            Row(
              children: [
                const SizedBox(width: 16),
                _buildTabItem('Hồ sơ sức khỏe', isActive: true),
                _buildTabItem('Quá trình điều trị', isActive: false),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF5F7FA) : Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? const Color(0xFF73C6D9) : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Section 1: Diagnosis
          _buildSectionCard(
            color: const Color(0xFFFFF8E1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFFFA000)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'CHẨN ĐOÁN MỚI NHẤT',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '10/01/2024',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  'Hiếm muộn nguyên phát / Rối loạn rụng trứng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBF360C),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Bác sĩ chỉ định: Ths.BS Phạm Văn Minh',
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Medical History
          _buildSectionCard(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiền sử bệnh lý',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Kinh nguyệt không đều (chu kỳ 45-60 ngày)'),
                _buildBulletPoint('Phẫu thuật nội soi u nang buồng trứng (2021)'),
                _buildBulletPoint('Không có tiền sử dị ứng thuốc'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: Lab Results
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kết quả xét nghiệm gần đây',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildLabResultCard(
            name: 'Định lượng FSH',
            value: '8.5 mIU/mL',
            date: '09/01/2024',
            isNormal: true,
          ),
          const SizedBox(height: 10),
          _buildLabResultCard(
            name: 'Định lượng AMH',
            value: '1.2 ng/mL',
            date: '09/01/2024',
            isNormal: false,
          ),
          const SizedBox(height: 16),

          // Section 5: Doctor
          _buildDoctorCard(),
          const SizedBox(height: 16),

          // Section 4: Contact
          _buildSectionCard(
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin liên hệ khẩn cấp',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.phone, color: Color(0xFF73C6D9), size: 20),
                    SizedBox(width: 12),
                    Text('Chồng: Trần Văn B - 0912 345 678'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF73C6D9), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text('Số 12, Ngõ 4, Nguyễn Trãi, Thanh Xuân, HN')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF73C6D9)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultCard({
    required String name,
    required String value,
    required String date,
    required bool isNormal,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNormal ? Colors.green[50] : Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.science,
              color: isNormal ? Colors.green : Colors.orange[800],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Ngày: $date',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isNormal ? Colors.green : Colors.orange[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isNormal ? 'Bình thường' : 'Bất thường',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA), // Xanh nhạt
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ths.BS Phạm Văn Minh',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF00838F),
                      ),
                    ),
                    Text('Trưởng khoa Hỗ trợ sinh sản',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildTag('Hỗ trợ sinh sản'),
              _buildTag('IVF'),
              _buildTag('Khám phụ khoa'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email_outlined, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Text('minh.pham@hospital.com',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF73C6D9), Color(0xFF4DADC2)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text(
                'Nhắn tin với bác sĩ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 11)),
      backgroundColor: Colors.white,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
