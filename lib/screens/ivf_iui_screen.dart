import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class IVFIUIScreen extends StatefulWidget {
  const IVFIUIScreen({super.key});

  @override
  State<IVFIUIScreen> createState() => _IVFIUIScreenState();
}

class _IVFIUIScreenState extends State<IVFIUIScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hỗ trợ IVF/IUI'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'IVF',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'IUI',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTab == 0 ? _IVFContent() : _IUIContent(),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (label == 'IVF' ? const Color(0xFFA8D5E2) : const Color(0xFFF4C2C2))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected 
                ? const Color(0xFF2C3E50)
                : const Color(0xFF718096),
          ),
        ),
      ),
    );
  }
}

class _IVFContent extends StatefulWidget {
  @override
  State<_IVFContent> createState() => _IVFContentState();
}

class _IVFContentState extends State<_IVFContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Thông tin về IVF',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Thụ tinh ống nghiệm (IVF) là kỹ thuật hỗ trợ sinh sản tiên tiến, '
                    'phù hợp cho các cặp vợ chồng gặp khó khăn trong việc thụ thai tự nhiên.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Process Steps
          const Text(
            'Quy trình IVF',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _ProcessStep(
            step: 1,
            title: 'Kích thích buồng trứng',
            description: 'Sử dụng thuốc nội tiết để kích thích buồng trứng sản xuất nhiều trứng',
          ),
          _ProcessStep(
            step: 2,
            title: 'Lấy trứng',
            description: 'Thủ thuật lấy trứng từ buồng trứng (thường mất 15-20 phút)',
          ),
          _ProcessStep(
            step: 3,
            title: 'Thụ tinh',
            description: 'Trứng và tinh trùng được thụ tinh trong phòng thí nghiệm',
          ),
          _ProcessStep(
            step: 4,
            title: 'Nuôi cấy phôi',
            description: 'Phôi được nuôi cấy trong 3-5 ngày trước khi chuyển',
          ),
          _ProcessStep(
            step: 5,
            title: 'Chuyển phôi',
            description: 'Chuyển phôi vào tử cung, thường 1-2 phôi',
          ),
          _ProcessStep(
            step: 6,
            title: 'Xét nghiệm thai',
            description: 'Xét nghiệm máu sau 10-14 ngày để xác nhận có thai',
          ),

          const SizedBox(height: 24),

          // Calendar
          const Text(
            'Lịch theo dõi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IUIContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Thông tin về IUI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bơm tinh trùng vào tử cung (IUI) là phương pháp ít xâm lấn hơn IVF, '
                    'phù hợp cho các trường hợp vô sinh nhẹ hoặc không rõ nguyên nhân.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Process Steps
          const Text(
            'Quy trình IUI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _ProcessStep(
            step: 1,
            title: 'Theo dõi rụng trứng',
            description: 'Siêu âm và xét nghiệm để xác định thời điểm rụng trứng',
          ),
          _ProcessStep(
            step: 2,
            title: 'Xử lý tinh trùng',
            description: 'Làm sạch và chọn lọc tinh trùng chất lượng tốt nhất',
          ),
          _ProcessStep(
            step: 3,
            title: 'Bơm tinh trùng',
            description: 'Bơm tinh trùng trực tiếp vào tử cung vào thời điểm rụng trứng',
          ),
          _ProcessStep(
            step: 4,
            title: 'Nghỉ ngơi',
            description: 'Nghỉ ngơi 15-30 phút sau thủ thuật',
          ),
          _ProcessStep(
            step: 5,
            title: 'Xét nghiệm thai',
            description: 'Xét nghiệm sau 2 tuần để xác nhận có thai',
          ),

          const SizedBox(height: 24),

          // Indications
          const Text(
            'IUI phù hợp cho',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _IndicationItem('Chất lượng tinh trùng nhẹ'),
                  const Divider(),
                  _IndicationItem('Vấn đề về cổ tử cung'),
                  const Divider(),
                  _IndicationItem('Không rõ nguyên nhân vô sinh'),
                  const Divider(),
                  _IndicationItem('Vô sinh do yếu tố miễn dịch'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final int step;
  final String title;
  final String description;

  const _ProcessStep({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicationItem extends StatelessWidget {
  final String text;

  const _IndicationItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

