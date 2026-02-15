import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final int totalCopies;
  final int availableCopies;
  final String? imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.totalCopies,
    required this.availableCopies,
    this.imageUrl,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Book(
      id: doc.id,
      title: data['title'] as String,
      author: data['author'] as String,
      description: data['description'] ?? '',
      totalCopies: data['totalCopies'] as int,
      availableCopies: data['availableCopies'] as int,
      imageUrl: data['imageUrl'], // 👈 NEW (optional)
    );
  }

  bool get isAvailable => availableCopies > 0;
}
