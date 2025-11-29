import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cycle_tracking_provider.dart';
import '../providers/health_profile_provider.dart';
import '../models/cycle_tracking.dart';

class TrackingScreen extends StatefulWidget {
  final DateTime date;

  const TrackingScreen({super.key, required this.date});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String? _selectedPeriod;
  String? _selectedMood;
  String? _selectedEnergy;
  String? _selectedSleep;
  final List<String> _selectedSymptoms = [];
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tracking = context.read<CycleTrackingProvider>().getTrackingForDate(widget.date);
    if (tracking != null) {
      _selectedPeriod = tracking.periodStart;
      _selectedMood = tracking.mood;
      _selectedEnergy = tracking.energy;
      _selectedSleep = tracking.sleep;
      _selectedSymptoms.addAll(tracking.symptoms);
      _notesController.text = tracking.notes ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveTracking() {
    final profile = context.read<HealthProfileProvider>().profile;
    final trackingProvider = context.read<CycleTrackingProvider>();
    
    final tracking = CycleTracking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: widget.date,
      periodStart: _selectedPeriod,
      mood: _selectedMood,
      energy: _selectedEnergy,
      sleep: _selectedSleep,
      symptoms: _selectedSymptoms,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      gender: profile?.gender ?? 'female',
    );
    
    trackingProvider.addTracking(tracking);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<HealthProfileProvider>().profile;
    final isFemale = profile?.gender == 'female';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Theo dõi'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF2C3E50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFemale) ...[
              _SectionTitle('Kinh nguyệt'),
              const SizedBox(height: 12),
              _PeriodSelector(
                selected: _selectedPeriod,
                onChanged: (value) => setState(() => _selectedPeriod = value),
              ),
            ],
            
            const SizedBox(height: 24),
            _SectionTitle('Tâm trạng'),
            const SizedBox(height: 12),
            _MoodSelector(
              selected: _selectedMood,
              onChanged: (value) => setState(() => _selectedMood = value),
            ),
            
            const SizedBox(height: 24),
            _SectionTitle('Năng lượng'),
            const SizedBox(height: 12),
            _EnergySelector(
              selected: _selectedEnergy,
              onChanged: (value) => setState(() => _selectedEnergy = value),
            ),
            
            const SizedBox(height: 24),
            _SectionTitle('Giấc ngủ'),
            const SizedBox(height: 12),
            _SleepSelector(
              selected: _selectedSleep,
              onChanged: (value) => setState(() => _selectedSleep = value),
            ),
            
            const SizedBox(height: 24),
            _SectionTitle('Triệu chứng'),
            const SizedBox(height: 12),
            _SymptomsSelector(
              selected: _selectedSymptoms,
              onChanged: (symptoms) => setState(() {}),
            ),
            
            const SizedBox(height: 24),
            _SectionTitle('Ghi chú'),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ghi chú của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTracking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _PeriodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionButton(
            label: 'Nhẹ',
            isSelected: selected == 'light',
            color: const Color(0xFFF4C2C2),
            onTap: () => onChanged('light'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Trung bình',
            isSelected: selected == 'medium',
            color: const Color(0xFFF4C2C2),
            onTap: () => onChanged('medium'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Nặng',
            isSelected: selected == 'heavy',
            color: const Color(0xFFF4C2C2),
            onTap: () => onChanged('heavy'),
          ),
        ),
      ],
    );
  }
}

class _MoodSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _MoodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'icon': Icons.sentiment_very_satisfied, 'label': 'Vui', 'value': 'happy'},
      {'icon': Icons.sentiment_satisfied, 'label': 'Bình thường', 'value': 'normal'},
      {'icon': Icons.sentiment_dissatisfied, 'label': 'Buồn', 'value': 'sad'},
      {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Lo lắng', 'value': 'anxious'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: moods.map((mood) {
        final isSelected = selected == mood['value'];
        return _MoodButton(
          icon: mood['icon'] as IconData,
          label: mood['label'] as String,
          isSelected: isSelected,
          onTap: () => onChanged(mood['value'] as String),
        );
      }).toList(),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFA8D5E2).withValues(alpha: 0.2)
              : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFA8D5E2) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFA8D5E2) : const Color(0xFF718096),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2C3E50) : const Color(0xFF718096),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnergySelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _EnergySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionButton(
            label: 'Thấp',
            isSelected: selected == 'low',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('low'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Trung bình',
            isSelected: selected == 'medium',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('medium'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Cao',
            isSelected: selected == 'high',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('high'),
          ),
        ),
      ],
    );
  }
}

class _SleepSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _SleepSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionButton(
            label: 'Kém',
            isSelected: selected == 'poor',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('poor'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Bình thường',
            isSelected: selected == 'fair',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('fair'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionButton(
            label: 'Tốt',
            isSelected: selected == 'good',
            color: const Color(0xFFA8D5E2),
            onTap: () => onChanged('good'),
          ),
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : const Color(0xFF718096),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SymptomsSelector extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const _SymptomsSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final symptoms = [
      'Đau bụng',
      'Đầy hơi',
      'Đau đầu',
      'Mệt mỏi',
      'Đau lưng',
      'Buồn nôn',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: symptoms.map((symptom) {
        final isSelected = selected.contains(symptom);
        return InkWell(
          onTap: () {
            if (isSelected) {
              selected.remove(symptom);
            } else {
              selected.add(symptom);
            }
            onChanged(selected);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFF4C2C2).withValues(alpha: 0.2)
                  : const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFF4C2C2) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              symptom,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2C3E50) : const Color(0xFF718096),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

