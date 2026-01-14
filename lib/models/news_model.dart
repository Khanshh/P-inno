class NewsModel {
  final String id;
  final String title;
  final String description;
  final String? category;
  final String? imageUrl;
  final int views;
  final String time;
  final DateTime? createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.imageUrl,
    required this.views,
    required this.time,
    this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      views: json['views'] as int,
      time: json['time'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

class NewsListResponse {
  final List<NewsModel> items;
  final int total;
  final int page;
  final int limit;
  final bool hasNext;

  NewsListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasNext,
  });

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
      items: (json['items'] as List)
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      hasNext: json['has_next'] as bool,
    );
  }
}

