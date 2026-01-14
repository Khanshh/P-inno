class DiscoverMethodModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String color;
  final String? description;
  final int order;

  DiscoverMethodModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.description,
    required this.order,
  });

  factory DiscoverMethodModel.fromJson(Map<String, dynamic> json) {
    return DiscoverMethodModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      description: json['description'] as String?,
      order: json['order'] as int,
    );
  }
}

class DiscoverMethodDetailModel extends DiscoverMethodModel {
  final String? content;

  DiscoverMethodDetailModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.icon,
    required super.color,
    super.description,
    required super.order,
    this.content,
  });

  factory DiscoverMethodDetailModel.fromJson(Map<String, dynamic> json) {
    return DiscoverMethodDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      description: json['description'] as String?,
      order: json['order'] as int,
      content: json['content'] as String?,
    );
  }
}

class InfertilityInfoModel {
  final String id;
  final String title;
  final String content;
  final List<Map<String, dynamic>>? sections;

  InfertilityInfoModel({
    required this.id,
    required this.title,
    required this.content,
    this.sections,
  });

  factory InfertilityInfoModel.fromJson(Map<String, dynamic> json) {
    return InfertilityInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      sections: json['sections'] != null
          ? List<Map<String, dynamic>>.from(json['sections'] as List)
          : null,
    );
  }
}

