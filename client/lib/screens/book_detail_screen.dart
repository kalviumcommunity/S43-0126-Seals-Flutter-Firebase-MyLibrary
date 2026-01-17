import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Author: ${book.author}'),
            const SizedBox(height: 20),
            Text(
              book.isAvailable ? 'Status: Available' : 'Status: Reserved',
              style: TextStyle(
                color: book.isAvailable ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: book.isAvailable ? () {} : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Reserve Book'),
            ),
          ],
        ),
      ),
    );
  }
}
