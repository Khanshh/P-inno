import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_profile_provider.dart';
import '../models/health_profile.dart';

class ProfileFormScreen extends StatefulWidget {
  final HealthProfile? profile;

  const ProfileFormScreen({super.key, this.profile});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _lastMenstrualPeriodController;
  late TextEditingController _cycleLengthController;
  
  DateTime? _selectedDate;
  String _selectedGender = 'female';
  List<String> _medicalHistory = [];
  List<String> _allergies = [];
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _heightController = TextEditingController(
      text: profile?.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profile?.weight?.toString() ?? '',
    );
    _bloodTypeController = TextEditingController(text: profile?.bloodType ?? '');
    _lastMenstrualPeriodController = TextEditingController(
      text: profile?.lastMenstrualPeriod ?? '',
    );
    _cycleLengthController = TextEditingController(
      text: profile?.cycleLength?.toString() ?? '',
    );
    _selectedDate = profile?.dateOfBirth;
    _selectedGender = profile?.gender ?? 'female';
    _medicalHistory = List.from(profile?.medicalHistory ?? []);
    _allergies = List.from(profile?.allergies ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _lastMenstrualPeriodController.dispose();
    _cycleLengthController.dispose();
    _medicalHistoryController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addMedicalHistory() {
    if (_medicalHistoryController.text.isNotEmpty) {
      setState(() {
        _medicalHistory.add(_medicalHistoryController.text);
        _medicalHistoryController.clear();
      });
    }
  }

  void _removeMedicalHistory(String item) {
    setState(() {
      _medicalHistory.remove(item);
    });
  }

  void _addAllergy() {
    if (_allergyController.text.isNotEmpty) {
      setState(() {
        _allergies.add(_allergyController.text);
        _allergyController.clear();
      });
    }
  }

  void _removeAllergy(String item) {
    setState(() {
      _allergies.remove(item);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = HealthProfile(
      id: widget.profile?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      dateOfBirth: _selectedDate,
      gender: _selectedGender,
      height: _heightController.text.isNotEmpty
          ? double.tryParse(_heightController.text)
          : null,
      weight: _weightController.text.isNotEmpty
          ? double.tryParse(_weightController.text)
          : null,
      bloodType: _bloodTypeController.text.isNotEmpty
          ? _bloodTypeController.text
          : null,
      medicalHistory: _medicalHistory,
      allergies: _allergies,
      lastMenstrualPeriod: _lastMenstrualPeriodController.text.isNotEmpty
          ? _lastMenstrualPeriodController.text
          : null,
      cycleLength: _cycleLengthController.text.isNotEmpty
          ? int.tryParse(_cycleLengthController.text)
          : null,
    );

    await context.read<HealthProfileProvider>().saveProfile(profile);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu hồ sơ thành công!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? 'Tạo hồ sơ' : 'Chỉnh sửa hồ sơ'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ và tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date of Birth
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Chọn ngày sinh',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Giới tính *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'female', child: Text('Nữ')),
                DropdownMenuItem(value: 'male', child: Text('Nam')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Height
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Chiều cao (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Cân nặng (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Blood Type
            TextFormField(
              controller: _bloodTypeController,
              decoration: const InputDecoration(
                labelText: 'Nhóm máu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bloodtype),
                hintText: 'VD: A, B, AB, O',
              ),
            ),
            const SizedBox(height: 16),

            // Female specific fields
            if (_selectedGender == 'female') ...[
              TextFormField(
                controller: _lastMenstrualPeriodController,
                decoration: const InputDecoration(
                  labelText: 'Kỳ kinh cuối',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                  hintText: 'VD: 01/01/2024',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cycleLengthController,
                decoration: const InputDecoration(
                  labelText: 'Độ dài chu kỳ (ngày)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timeline),
                  hintText: 'VD: 28',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Medical History
            const Text(
              'Tiền sử bệnh lý',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _medicalHistoryController,
                    decoration: const InputDecoration(
                      labelText: 'Thêm tiền sử bệnh',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) => _addMedicalHistory(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addMedicalHistory,
                ),
              ],
            ),
            if (_medicalHistory.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _medicalHistory.map((item) {
                  return Chip(
                    label: Text(item),
                    onDeleted: () => _removeMedicalHistory(item),
                    backgroundColor: Colors.blue[50],
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),

            // Allergies
            const Text(
              'Dị ứng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _allergyController,
                    decoration: const InputDecoration(
                      labelText: 'Thêm dị ứng',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) => _addAllergy(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addAllergy,
                ),
              ],
            ),
            if (_allergies.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allergies.map((item) {
                  return Chip(
                    label: Text(item),
                    onDeleted: () => _removeAllergy(item),
                    backgroundColor: Colors.red[50],
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Lưu hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }
}

