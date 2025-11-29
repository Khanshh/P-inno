import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/couple_provider.dart';
import '../providers/health_profile_provider.dart';
import '../models/couple.dart';
import '../models/health_profile.dart';

class CoupleScreen extends StatefulWidget {
  const CoupleScreen({super.key});

  @override
  State<CoupleScreen> createState() => _CoupleScreenState();
}

class _CoupleScreenState extends State<CoupleScreen> {
  final TextEditingController _partnerIdController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _partnerIdController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupleProvider = context.watch<CoupleProvider>();
    final couple = coupleProvider.couple;
    final profile = context.watch<HealthProfileProvider>().profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cặp đôi'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: couple == null
          ? _EmptyCoupleView(
              profile: profile,
              coupleProvider: coupleProvider,
              partnerIdController: _partnerIdController,
            )
          : _CoupleView(
              couple: couple,
              profile: profile,
              coupleProvider: coupleProvider,
              noteController: _noteController,
            ),
    );
  }
}

class _EmptyCoupleView extends StatelessWidget {
  final HealthProfile? profile;
  final CoupleProvider coupleProvider;
  final TextEditingController partnerIdController;

  const _EmptyCoupleView({
    required this.profile,
    required this.coupleProvider,
    required this.partnerIdController,
  });

  Future<void> _connectPartner(BuildContext context) async {
    if (partnerIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập ID đối tác')),
      );
      return;
    }

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng tạo hồ sơ sức khỏe trước')),
      );
      return;
    }

    await coupleProvider.createCouple(
      profile!.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      partnerIdController.text.trim(),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã kết nối với đối tác thành công!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa kết nối với đối tác',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kết nối với đối tác để chia sẻ thông tin và theo dõi cùng nhau',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            if (profile != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID của bạn:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        profile!.id ?? 'Chưa có ID',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          final id = profile!.id ?? DateTime.now().millisecondsSinceEpoch.toString();
                          Clipboard.setData(ClipboardData(text: id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã sao chép ID vào clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Sao chép ID'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: partnerIdController,
                decoration: const InputDecoration(
                  labelText: 'Nhập ID đối tác',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_add),
                  hintText: 'Nhập ID của đối tác',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _connectPartner(context),
                icon: const Icon(Icons.link),
                label: const Text('Kết nối'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ] else
              const Text(
                'Vui lòng tạo hồ sơ sức khỏe trước khi kết nối',
                style: TextStyle(color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}

class _CoupleView extends StatelessWidget {
  final Couple couple;
  final HealthProfile? profile;
  final CoupleProvider coupleProvider;
  final TextEditingController noteController;

  const _CoupleView({
    required this.couple,
    required this.profile,
    required this.coupleProvider,
    required this.noteController,
  });

  Future<void> _addNote(BuildContext context) async {
    if (noteController.text.trim().isEmpty) return;
    if (profile == null) return;

    await coupleProvider.addSharedNote(
      noteController.text.trim(),
      profile!.id ?? '',
    );

    noteController.clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm ghi chú')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Couple Info Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFA8D5E2).withValues(alpha: 0.3),
                const Color(0xFFF4C2C2).withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PartnerAvatar(profile?.name ?? 'Bạn'),
                  const SizedBox(width: 16),
                  const Icon(Icons.favorite, color: Colors.white),
                  const SizedBox(width: 16),
                  _PartnerAvatar('Đối tác'),
                ],
              ),
              const SizedBox(height: 16),
              if (couple.relationshipStartDate != null)
                Text(
                  'Kết nối từ ${DateFormat('dd/MM/yyyy').format(couple.relationshipStartDate!)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),

        // Tabs
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Ghi chú chung'),
                    Tab(text: 'Lịch hẹn'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _SharedNotesTab(
                        notes: couple.sharedNotes,
                        profile: profile,
                        noteController: noteController,
                        onAddNote: () => _addNote(context),
                      ),
                      _AppointmentsTab(
                        appointments: couple.appointments,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final String name;

  const _PartnerAvatar(this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SharedNotesTab extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final HealthProfile? profile;
  final TextEditingController noteController;
  final VoidCallback onAddNote;

  const _SharedNotesTab({
    required this.notes,
    required this.profile,
    required this.noteController,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Note Input
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: 'Viết ghi chú...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onAddNote,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Notes List
        Expanded(
          child: notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có ghi chú',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[notes.length - 1 - index];
                    final isOwnNote = note['authorId'] == profile?.id;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isOwnNote
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          child: Icon(
                            isOwnNote ? Icons.person : Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(note['content'] ?? ''),
                        subtitle: Text(
                          note['timestamp'] != null
                              ? DateFormat('dd/MM/yyyy HH:mm')
                                  .format(DateTime.parse(note['timestamp']))
                              : '',
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AppointmentsTab extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;

  const _AppointmentsTab({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Chưa có lịch hẹn',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[appointments.length - 1 - index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(appointment['title'] ?? 'Lịch hẹn'),
                  subtitle: Text(
                    appointment['date'] ?? '',
                  ),
                ),
              );
            },
          );
  }
}

