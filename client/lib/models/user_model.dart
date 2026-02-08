class AppUser {
  final String id;
  final String email;
  final String role; // 'student' or 'admin'

  AppUser({
    required this.id,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'],
      role: data['role'] ?? 'student',
    );
  }

  bool get isAdmin => role == 'admin';
}
