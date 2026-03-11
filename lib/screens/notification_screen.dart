import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _error;

  late AnimationController _backgroundController;

  // Premium Theme Colors (Modern Health-Tech)
  final Color _primaryColor = const Color(0xFF1D4E56); // Deep Teal
  final Color _accentColor = const Color(0xFF73C6D9); // Hopeful gradient start

  // Soft UI / Neumorphism Colors
  final Color _bgColor = const Color(0xFFF8FBFF); // Matches Onboarding
  final Color _lightShadow = Colors.white;
  final Color _darkShadow = const Color(0xFFD1D9E6); // Soft blue-grey shadow

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadNotifications();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifications = await _apiService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
            children: [
              _buildGlassHeader(),
              _buildMarkAllReadButton(),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: _accentColor))
                    : _error != null
                        ? Center(child: Text(_error!, style: GoogleFonts.plusJakartaSans(color: Colors.red)))
                        : _buildNotificationList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 50 + (30 * _backgroundController.value),
              right: -100 + (20 * _backgroundController.value),
              child: _buildOrb(400, const Color(0xFFE2F1AF).withOpacity(0.3)),
            ),
            Positioned(
              bottom: -150 + (40 * _backgroundController.value),
              left: -120 + (30 * _backgroundController.value),
              child: _buildOrb(450, const Color(0xFFD1F1F1).withOpacity(0.5)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF73C6D9), Color(0xFF4A9EAD)], // Hopeful gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Thông báo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 25, // +3 size
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkAllReadButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          setState(() {
            for (var notification in _notifications) {
              notification.isRead = true;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accentColor.withOpacity(0.2)),
          ),
          child: Text(
            'Đánh dấu tất cả là đã đọc',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4A9EAD),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    if (_notifications.isEmpty) {
      return Center(
        child: Text(
          'Không có thông báo nào',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade400,
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _NotificationItemWidget(
          notification: notification,
          accentColor: const Color(0xFF4A9EAD),
          bgColor: _bgColor,
          darkShadow: _darkShadow,
          lightShadow: _lightShadow,
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
          },
        );
      },
    );
  }
}

class _NotificationItemWidget extends StatelessWidget {
  const _NotificationItemWidget({
    required this.notification,
    required this.accentColor,
    required this.bgColor,
    required this.darkShadow,
    required this.lightShadow,
    required this.onTap,
  });

  final NotificationModel notification;
  final Color accentColor;
  final Color bgColor;
  final Color darkShadow;
  final Color lightShadow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: notification.isRead ? bgColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkShadow.withOpacity(notification.isRead ? 0.3 : 0.5),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: lightShadow,
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
        border: notification.isRead 
          ? Border.all(color: Colors.white, width: 1)
          : Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: darkShadow.withOpacity(0.3), blurRadius: 4, offset: const Offset(2, 2)),
                      BoxShadow(color: lightShadow, blurRadius: 4, offset: const Offset(-2, -2)),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getIconData(notification.icon),
                      color: _parseColor(notification.iconColor),
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17, // +2 size
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1D4E56),
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(top: 4, left: 8),
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15, // +2 size
                          color: Colors.blueGrey.shade600,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.time,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: notification.isRead
                                  ? Colors.grey.shade400
                                  : accentColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calendar_today':
        return Icons.calendar_today_rounded;
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'chat_bubble':
        return Icons.chat_bubble_rounded;
      case 'notifications_active':
        return Icons.notifications_active_rounded;
      case 'info':
        return Icons.info_outline_rounded;
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
      }
      return const Color(0xFF4A9EAD);
    } catch (e) {
      return const Color(0xFF4A9EAD);
    }
  }
}