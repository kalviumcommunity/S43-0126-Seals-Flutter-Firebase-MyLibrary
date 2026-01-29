import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/reservation_service.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final ReservationService reservationService = ReservationService();

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Author: ${book.author}'),
            const SizedBox(height: 10),
            Text(
              'Available: ${book.availableCopies} / ${book.totalCopies}',
            ),
            const SizedBox(height: 20),
            Text(
              book.isAvailable ? 'Status: Available' : 'Status: Out of Stock',
              style: TextStyle(
                color: book.isAvailable ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: book.isAvailable
                  ? () async {
                      try {
                        await reservationService.reserveBook(book.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book reserved successfully'),
                          ),
                        );

                        Navigator.pop(context); // back to list
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    }
                  : null,
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
