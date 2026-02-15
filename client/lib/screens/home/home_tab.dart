import 'package:flutter/material.dart';

import '../books/book_list_screen.dart';
import '../my_reservations_screen.dart';
import '../admin/admin_return_requests_screen.dart';
import '../admin/admin_issue_books_screen.dart';

class HomeTab extends StatelessWidget {
  final bool isAdmin;

  const HomeTab({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Dashboard' : 'Library Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ================= ADMIN MODE BANNER =================
            if (isAdmin) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Admin Mode Enabled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ================= OVERVIEW =================
            _sectionTitle(isAdmin ? 'Overview' : 'Your Library'),
            const SizedBox(height: 12),

            Row(
              children: [
                _statCard(
                  icon: Icons.menu_book,
                  title: 'Books',
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 12),
                _statCard(
                  icon: Icons.bookmark,
                  title: isAdmin ? 'Issued' : 'Reserved',
                  color: Colors.indigo,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ================= STUDENT ACTIONS =================
            _sectionTitle('Student Actions'),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _actionCard(
                  title: 'Browse Books',
                  icon: Icons.menu_book,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookListScreen(),
                      ),
                    );
                  },
                ),
                _actionCard(
                  title: 'My Activity',
                  icon: Icons.bookmark,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyReservationsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // ================= ADMIN ACTIONS =================
            if (isAdmin) ...[
              const SizedBox(height: 28),
              _sectionTitle('Admin Actions'),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _actionCard(
                    title: 'Issue Books',
                    icon: Icons.assignment_turned_in,
                    color: Colors.deepOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AdminIssueBooksScreen(),
                        ),
                      );
                    },
                  ),
                  _actionCard(
                    title: 'Return Requests',
                    icon: Icons.assignment_return,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdminReturnRequestsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
