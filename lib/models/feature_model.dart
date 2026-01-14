class FeatureModel {
  final String id;
  final String title;
  final String icon;
  final String? description;
  final String? route;
  final int order;

  FeatureModel({
    required this.id,
    required this.title,
    required this.icon,
    this.description,
    this.route,
    required this.order,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String?,
      route: json['route'] as String?,
      order: json['order'] as int,
    );
  }
}

