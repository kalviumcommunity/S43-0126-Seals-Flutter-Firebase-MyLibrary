import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../books/book_list_screen.dart';
import '../my_reservations_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_return_requests_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAdmin = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      _isAdmin = doc.data()?['role'] == 'admin';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(child: _buildDashboardGrid(context)),
          ],
        ),
      ),
    );
  }

  // ================= UI SECTIONS =================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isAdmin ? 'Welcome, Admin 👋' : 'Welcome, Student 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _isAdmin
              ? 'Manage books, issues, and returns'
              : 'Browse books and track your activity',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _dashboardCard(
          icon: Icons.menu_book,
          title: 'Browse Books',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookListScreen()),
            );
          },
        ),

        _dashboardCard(
          icon: Icons.bookmark,
          title: 'My Reservations',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyReservationsScreen(),
              ),
            );
          },
        ),

        // 👮 ADMIN ONLY
        if (_isAdmin)
          _dashboardCard(
            icon: Icons.assignment_turned_in,
            title: 'Return Requests',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminReturnRequestsScreen(),
                ),
              );
            },
          ),

        _dashboardCard(
          icon: Icons.person,
          title: 'Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= DASHBOARD CARD =================

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: Colors.blue),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
