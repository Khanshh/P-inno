import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_profile_provider.dart';
import '../models/health_profile.dart';
import '../widgets/profile_form.dart';

class HealthProfileScreen extends StatelessWidget {
  const HealthProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<HealthProfileProvider>();
    final profile = profileProvider.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hồ sơ sức khỏe'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              color: const Color(0xFFA8D5E2),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileFormScreen(profile: profile),
                  ),
                );
              },
            ),
        ],
      ),
      body: profile == null
          ? _EmptyProfileView(profileProvider: profileProvider)
          : _ProfileView(profile: profile, profileProvider: profileProvider),
    );
  }
}

class _EmptyProfileView extends StatelessWidget {
  final HealthProfileProvider profileProvider;

  const _EmptyProfileView({required this.profileProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5E2).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add,
                size: 64,
                color: const Color(0xFFA8D5E2),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Chưa có hồ sơ sức khỏe',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tạo hồ sơ để bắt đầu sử dụng ứng dụng',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo hồ sơ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final HealthProfile profile;
  final HealthProfileProvider profileProvider;

  const _ProfileView({
    required this.profile,
    required this.profileProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Card(
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFA8D5E2).withValues(alpha: 0.1),
                    const Color(0xFFF4C2C2).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8D5E2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: profile.gender == 'female' 
                                ? const Color(0xFFF4C2C2).withValues(alpha: 0.2)
                                : const Color(0xFFA8D5E2).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            profile.gender == 'female' ? 'Nữ' : 'Nam',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: profile.gender == 'female' 
                                  ? const Color(0xFFF4C2C2)
                                  : const Color(0xFFA8D5E2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Basic Information
          Text(
            'Thông tin cơ bản',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Ngày sinh',
                    value: profile.dateOfBirth != null
                        ? DateFormat('dd/MM/yyyy').format(profile.dateOfBirth!)
                        : 'Chưa cập nhật',
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFE8E8E8)),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: 'Tuổi',
                    value: profile.age?.toString() ?? 'Chưa cập nhật',
                  ),
                  if (profile.height != null) ...[
                    const SizedBox(height: 16),
                    Container(height: 1, color: const Color(0xFFE8E8E8)),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Chiều cao',
                      value: '${profile.height} cm',
                    ),
                  ],
                  if (profile.weight != null) ...[
                    const SizedBox(height: 16),
                    Container(height: 1, color: const Color(0xFFE8E8E8)),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Cân nặng',
                      value: '${profile.weight} kg',
                    ),
                  ],
                  if (profile.bmi != null) ...[
                    const SizedBox(height: 16),
                    Container(height: 1, color: const Color(0xFFE8E8E8)),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'BMI',
                      value: profile.bmi!.toStringAsFixed(1),
                    ),
                  ],
                  if (profile.bloodType != null) ...[
                    const SizedBox(height: 16),
                    Container(height: 1, color: const Color(0xFFE8E8E8)),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Nhóm máu',
                      value: profile.bloodType!,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Female specific info
          if (profile.gender == 'female') ...[
            const SizedBox(height: 32),
            Text(
              'Thông tin chu kỳ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (profile.lastMenstrualPeriod != null)
                      _InfoRow(
                        label: 'Kỳ kinh cuối',
                        value: profile.lastMenstrualPeriod!,
                      ),
                    if (profile.cycleLength != null) ...[
                      if (profile.lastMenstrualPeriod != null) ...[
                        const SizedBox(height: 16),
                        Container(height: 1, color: const Color(0xFFE8E8E8)),
                        const SizedBox(height: 16),
                      ],
                      _InfoRow(
                        label: 'Độ dài chu kỳ',
                        value: '${profile.cycleLength} ngày',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // Medical History
          if (profile.medicalHistory.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              'Tiền sử bệnh lý',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: profile.medicalHistory
                      .map((history) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA8D5E2).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              history,
                              style: const TextStyle(
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],

          // Allergies
          if (profile.allergies.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              'Dị ứng',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: profile.allergies
                      .map((allergy) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4C2C2).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              allergy,
                              style: const TextStyle(
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF718096),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}

