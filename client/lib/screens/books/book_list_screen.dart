import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../services/firestore_service.dart';
import '../book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Books')),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),

          // 📚 BOOK LIST
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: _firestoreService.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No books available'));
                }

                final books = snapshot.data!
                    .where((book) =>
                        book.title.toLowerCase().contains(_searchQuery) ||
                        book.author.toLowerCase().contains(_searchQuery))
                    .toList();

                if (books.isEmpty) {
                  return const Center(child: Text('No matching books'));
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: book.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  book.imageUrl!,
                                  width: 45,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.menu_book, size: 40),
                        title: Text(book.title),
                        subtitle: Text(
                          'Author: ${book.author}\n'
                          'Available: ${book.availableCopies}/${book.totalCopies}',
                        ),
                        trailing: Text(
                          book.isAvailable ? 'Available' : 'Out of Stock',
                          style: TextStyle(
                            color: book.isAvailable
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookDetailScreen(book: book),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
