import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class SimulationHistoryScreen extends StatefulWidget {
  const SimulationHistoryScreen({super.key});

  @override
  State<SimulationHistoryScreen> createState() => _SimulationHistoryScreenState();
}

class _SimulationHistoryScreenState extends State<SimulationHistoryScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _history = [];
  
  // Premium Theme Colors
  final Color _primaryColor = const Color(0xFF1D4E56);
  final Color _bgColor = const Color(0xFFF8FBFF);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _apiService.getSimulationHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text(
          'Lịch sử đánh giá khả năng',
          style: GoogleFonts.plusJakartaSans(
            color: _primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Text(
                    'Chưa có lịch sử làm đánh giá.',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final dateStr = item['created_at'] ?? '';
                    String displayDate = 'Chưa rõ thời gian';
                    try {
                      final dt = DateTime.parse(dateStr).toLocal();
                      displayDate = DateFormat('dd/MM/yyyy HH:mm').format(dt);
                    } catch (_) {}

                    final modelName = item['model_id'] == 'hunault'
                        ? 'Đánh giá thụ thai tự nhiên'
                        : 'Đánh giá thành công IVF';
                    
                    final result = item['result'] ?? {};
                    final prob = result['probability_percent'] ?? 0;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
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
                              Icon(
                                item['model_id'] == 'hunault'
                                    ? Icons.favorite_rounded
                                    : Icons.science_rounded,
                                color: const Color(0xFF4A9EAD),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  modelName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: _primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            displayDate,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.blueGrey.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Xác suất thành công:',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.blueGrey.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A9EAD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${prob.toInt()}%',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF4A9EAD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
