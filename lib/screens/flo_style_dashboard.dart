import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/health_profile_provider.dart';
import '../providers/cycle_tracking_provider.dart';
import '../models/cycle_tracking.dart';
import 'tracking_screen.dart';

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class FloStyleDashboard extends StatefulWidget {
  const FloStyleDashboard({super.key});

  @override
  State<FloStyleDashboard> createState() => _FloStyleDashboardState();
}

class _FloStyleDashboardState extends State<FloStyleDashboard> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;


  @override
  Widget build(BuildContext context) {
    final profile = context.watch<HealthProfileProvider>().profile;
    final trackingProvider = context.watch<CycleTrackingProvider>();
    final todayTracking = trackingProvider.getTrackingForDate(_selectedDay);
    final isFemale = profile?.gender == 'female';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: const Color(0xFF2C3E50),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  profile != null ? 'Hello, ${profile.name}' : 'P-Inno',
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Color(0xFF2C3E50)),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Calendar Section - Large like Flo
            SliverToBoxAdapter(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                child: Column(
                  children: [
                    // Calendar
                    TableCalendar(
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
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      eventLoader: (day) {
                        final tracking = trackingProvider.getTrackingForDate(day);
                        if (tracking != null) {
                          return ['tracked'];
                        }
                        return [];
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF7FB3D3).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF7FB3D3),
                            width: 2,
                          ),
                        ),
                        selectedDecoration: BoxDecoration(
                          color: isFemale ? const Color(0xFFE8B4B8) : const Color(0xFF7FB3D3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: isFemale ? const Color(0xFFE8B4B8) : const Color(0xFF7FB3D3),
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        weekendTextStyle: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w400,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        todayTextStyle: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        leftChevronVisible: true,
                        rightChevronVisible: true,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                        ),
                        weekendStyle: TextStyle(
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),

            // Today's Status Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TodayStatusCard(
                  date: _selectedDay,
                  tracking: todayTracking,
                  isFemale: isFemale,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackingScreen(date: _selectedDay),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Quick Tracking Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Track',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _QuickTrackingButtons(
                      isFemale: isFemale,
                      onTrack: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrackingScreen(date: DateTime.now()),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StatsCards(isFemale: isFemale),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _TodayStatusCard extends StatelessWidget {
  final DateTime date;
  final CycleTracking? tracking;
  final bool isFemale;
  final VoidCallback onTap;

  const _TodayStatusCard({
    required this.date,
    this.tracking,
    required this.isFemale,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    final isToday = isSameDay(date, DateTime.now());
    final hasTracking = tracking != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFemale 
                ? const Color(0xFFE8B4B8).withValues(alpha: 0.3)
                : const Color(0xFF7FB3D3).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (isFemale ? const Color(0xFFE8B4B8) : const Color(0xFF7FB3D3))
                      .withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasTracking ? Icons.check_circle : Icons.add_circle_outline,
                  color: isFemale ? const Color(0xFFE8B4B8) : const Color(0xFF7FB3D3),
                  size: 28,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isToday ? 'Today' : 'Day ${date.day}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hasTracking
                        ? (isFemale
                            ? 'Cycle recorded'
                            : 'Health recorded')
                        : 'Tap to track',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTrackingButtons extends StatelessWidget {
  final bool isFemale;
  final VoidCallback onTrack;

  const _QuickTrackingButtons({
    required this.isFemale,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    if (isFemale) {
      return Row(
        children: [
          Expanded(
            child:                 _QuickButton(
                  icon: Icons.water_drop,
                  label: 'Period',
                  color: const Color(0xFFE8B4B8),
                  onTap: onTrack,
                ),
              ),
          const SizedBox(width: 16),
          Expanded(
            child: _QuickButton(
              icon: Icons.mood,
              label: 'Mood',
              color: const Color(0xFF7FB3D3),
              onTap: onTrack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _QuickButton(
              icon: Icons.favorite,
              label: 'Symptoms',
              color: const Color(0xFF7FB3D3),
              onTap: onTrack,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _QuickButton(
              icon: Icons.fitness_center,
              label: 'Health',
              color: const Color(0xFF7FB3D3),
              onTap: onTrack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _QuickButton(
              icon: Icons.mood,
              label: 'Mood',
              color: const Color(0xFFE8B4B8),
              onTap: onTrack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _QuickButton(
              icon: Icons.energy_savings_leaf,
              label: 'Energy',
              color: const Color(0xFF7FB3D3),
              onTap: onTrack,
            ),
          ),
        ],
      );
    }
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCards extends StatelessWidget {
  final bool isFemale;

  const _StatsCards({required this.isFemale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: isFemale ? 'Cycle' : 'Health',
            value: '28',
            unit: isFemale ? 'days' : 'points',
            color: isFemale ? const Color(0xFFE8B4B8) : const Color(0xFF7FB3D3),
            icon: isFemale ? Icons.calendar_today : Icons.health_and_safety,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Tracking',
            value: '12',
            unit: 'days',
            color: const Color(0xFF7FB3D3),
            icon: Icons.track_changes,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  value,
                  key: ValueKey(value),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

