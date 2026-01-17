import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatelessWidget {
  BookListScreen({super.key});

  final List<Book> books = [
    Book(id: '1', title: 'Clean Code', author: 'Robert C. Martin', isAvailable: true),
    Book(id: '2', title: 'Flutter in Action', author: 'Eric Windmill', isAvailable: false),
    Book(id: '3', title: 'Design Patterns', author: 'GoF', isAvailable: true),
    Book(id: '4', title: 'Introduction to Algorithms', author: 'CLRS', isAvailable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Books')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(book.title),
              subtitle: Text('Author: ${book.author}'),
              trailing: Text(
                book.isAvailable ? 'Available' : 'Reserved',
                style: TextStyle(
                  color: book.isAvailable ? Colors.green : Colors.red,
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
      ),
    );
  }
}
