
class NotificationModel {
  final String id;
  final String icon;
  final String iconColor;
  final String title;
  final String description;
  final String time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      icon: json['icon'],
      iconColor: json['icon_color'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      isRead: json['is_read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'icon_color': iconColor,
      'title': title,
      'description': description,
      'time': time,
      'is_read': isRead,
    };
  }
}
