import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/reservation_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isReserving = false;

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
            // 🔧 IMAGE OR PLACEHOLDER ABOVE TITLE
            if (widget.book.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.book.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Author: ${widget.book.author}'),
            const SizedBox(height: 10),
            Text('Available: ${widget.book.availableCopies} / ${widget.book.totalCopies}'),
            const SizedBox(height: 20),
            Text(
              widget.book.isAvailable ? 'Status: Available' : 'Status: Out of Stock',
              style: TextStyle(
                color: widget.book.isAvailable ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: widget.book.isAvailable && !_isReserving
                  ? () async {
                      setState(() {
                        _isReserving = true;
                      });
                      try {
                        await reservationService.reserveBook(
                          bookId: widget.book.id,
                          bookTitle: widget.book.title,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book reserved successfully'),
                          ),
                        );

                        Navigator.pop(context); // back to list
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isReserving = false;
                          });
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isReserving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Reserve Book'),
            ),
          ],
        ),
      ),
    );
  }
}
