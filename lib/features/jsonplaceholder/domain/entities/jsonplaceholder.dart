class JsonPlaceholder {
  final int id;
  final int userId;
  final String title;
  final String body;

  JsonPlaceholder({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory JsonPlaceholder.fromJson(Map<String, dynamic> json) {
    return JsonPlaceholder(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.tryParse(json['userId']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  JsonPlaceholder copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return JsonPlaceholder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
