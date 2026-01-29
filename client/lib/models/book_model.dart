import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final int totalCopies;
  final int availableCopies;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.totalCopies,
    required this.availableCopies,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Book(
      id: doc.id,
      title: data['title'],
      author: data['author'],
      description: data['description'],
      totalCopies: data['totalCopies'],
      availableCopies: data['availableCopies'],
    );
  }

  bool get isAvailable => availableCopies > 0;
}
