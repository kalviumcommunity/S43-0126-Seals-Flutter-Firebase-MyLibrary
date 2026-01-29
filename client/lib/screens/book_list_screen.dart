import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/firestore_service.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatelessWidget {
  BookListScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Books')),
      body: StreamBuilder<List<Book>>(
        stream: _firestoreService.getBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available'));
          }

          final books = snapshot.data!;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(book.title),
                  subtitle: Text(
                    'Author: ${book.author}\n'
                    'Available: ${book.availableCopies} / ${book.totalCopies}',
                  ),
                  trailing: Text(
                    book.isAvailable ? 'Available' : 'Out of Stock',
                    style: TextStyle(
                      color:
                          book.isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
