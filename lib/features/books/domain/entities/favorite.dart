class Favorite {
  final String id;
  final String userId;
  final String bookId;
  final int rating; // 1 to 5
  final int currentPage;

  Favorite({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.rating,
    required this.currentPage,
  });

  factory Favorite.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Favorite(
      id: documentId,
      userId: json['userId'] ?? '',
      bookId: json['bookId'] ?? '',
      rating: json['rating'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestoreFields() {
    return {
      'userId': userId,
      'bookId': bookId,
      'rating': rating,
      'currentPage': currentPage,
    };
  }

  Favorite copyWith({
    String? id,
    String? userId,
    String? bookId,
    int? rating,
    int? currentPage,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      rating: rating ?? this.rating,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
