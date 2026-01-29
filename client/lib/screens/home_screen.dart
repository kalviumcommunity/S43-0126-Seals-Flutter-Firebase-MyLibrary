import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'my_reservations_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMenuCard(
              context,
              title: '📚 Browse Books',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookListScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: '🗂 My Reservations',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  MyReservationsScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: '👤 Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
