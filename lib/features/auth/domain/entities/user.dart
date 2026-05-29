class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' o 'lector'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json, String documentId) {
    return User(
      id: documentId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'lector',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
