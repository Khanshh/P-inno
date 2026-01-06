import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Color _primaryColor = const Color(0xFF73C6D9);

  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      id: '1',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFF4CAF50),
      title: 'Lịch khám thai tuần này',
      description: 'Bạn có lịch khám thai vào thứ 3, 15/01/2024 lúc 9:00',
      time: '5 phút trước',
      isRead: false,
    ),
    _NotificationItem(
      id: '2',
      icon: Icons.medical_services,
      iconColor: const Color(0xFF2196F3),
      title: 'Kết quả xét nghiệm mới',
      description: 'Kết quả xét nghiệm máu của bạn đã có sẵn',
      time: '1 giờ trước',
      isRead: false,
    ),
    _NotificationItem(
      id: '3',
      icon: Icons.chat_bubble,
      iconColor: const Color(0xFFFF9800),
      title: 'Tin nhắn từ bác sĩ',
      description: 'Bác sĩ Nguyễn Văn A đã gửi cho bạn một tin nhắn',
      time: '2 giờ trước',
      isRead: true,
    ),
    _NotificationItem(
      id: '4',
      icon: Icons.notifications_active,
      iconColor: const Color(0xFF9C27B0),
      title: 'Nhắc nhở uống thuốc',
      description: 'Đã đến giờ uống vitamin D và sắt',
      time: '3 giờ trước',
      isRead: true,
    ),
    _NotificationItem(
      id: '5',
      icon: Icons.info,
      iconColor: const Color(0xFF607D8B),
      title: 'Cập nhật ứng dụng',
      description: 'Phiên bản mới của ứng dụng đã có sẵn',
      time: 'Hôm qua',
      isRead: true,
    ),
    _NotificationItem(
      id: '6',
      icon: Icons.local_hospital,
      iconColor: const Color(0xFFE91E63),
      title: 'Lịch tiêm phòng',
      description: 'Nhắc nhở: Tiêm phòng cúm trong tuần này',
      time: '2 ngày trước',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMarkAllReadButton(),
          Expanded(
            child: _buildNotificationList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Thông báo',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMarkAllReadButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          setState(() {
            for (var notification in _notifications) {
              notification.isRead = true;
            }
          });
        },
        child: Text(
          'Đánh dấu tất cả là đã đọc',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _NotificationItemWidget(
          notification: notification,
          primaryColor: _primaryColor,
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
    required this.primaryColor,
    required this.onTap,
  });

  final _NotificationItem notification;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : primaryColor.withOpacity(0.08),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification.iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: notification.isRead
                          ? Colors.grey.shade600
                          : primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onPressed: () {
                // TODO: Show options menu
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  _NotificationItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
  });

  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  bool isRead;
}

