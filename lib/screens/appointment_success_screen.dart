import 'package:flutter/material.dart';

class AppointmentSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentSuccessScreen({super.key, required this.appointmentData});

  final Color _primaryColor = const Color(0xFF73C6D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryColor.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(
                  Icons.check_rounded,
                  size: 80,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Đặt lịch thành công!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              
              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryColor.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã lịch hẹn', '#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
                    const Divider(height: 24),
                    _buildInfoRow('Bệnh nhân', appointmentData['patientName'] ?? 'Nguyễn Văn A'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Ngày khám', appointmentData['date'] ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Thời gian', appointmentData['time'] ?? 'N/A'),
                    const SizedBox(height: 12),
                     _buildInfoRow('Chuyên khoa', appointmentData['department'] ?? 'N/A'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7), // Light Yellow
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Đang chờ bệnh viện xác nhận. Vui lòng theo dõi thông báo.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home or root
                     Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'VỀ MÀN HÌNH CHÍNH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
