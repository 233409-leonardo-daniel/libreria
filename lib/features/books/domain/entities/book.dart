class Book {
  final String id;
  final String idPublisher;
  final String name;
  final String classification;
  final int pages;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.idPublisher,
    required this.name,
    required this.classification,
    required this.pages,
    required this.createdAt,
  });

  factory Book.fromFirestore(Map<String, dynamic> json, String documentId) {
    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] is DateTime) {
      parsedDate = json['createdAt'];
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.tryParse(json['createdAt']) ?? DateTime.now();
    }

    return Book(
      id: documentId,
      idPublisher: json['idPublisher']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      classification: json['classification']?.toString() ?? '',
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toFirestoreFields() {
    return {
      'idPublisher': idPublisher,
      'name': name,
      'classification': classification,
      'pages': pages,
      'createdAt': createdAt,
    };
  }

  Book copyWith({
    String? id,
    String? idPublisher,
    String? name,
    String? classification,
    int? pages,
    DateTime? createdAt,
  }) {
    return Book(
      id: id ?? this.id,
      idPublisher: idPublisher ?? this.idPublisher,
      name: name ?? this.name,
      classification: classification ?? this.classification,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
