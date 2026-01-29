class OnboardingPageModel {
  final String title;
  final String description;
  final String icon;
  final List<String> colors;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
  });

  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      colors: List<String>.from(json['colors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'colors': colors,
    };
  }
}
