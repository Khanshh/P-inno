class DailyTipModel {
  final String title;
  final String content;

  DailyTipModel({
    required this.title,
    required this.content,
  });

  factory DailyTipModel.fromJson(Map<String, dynamic> json) {
    return DailyTipModel(
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
