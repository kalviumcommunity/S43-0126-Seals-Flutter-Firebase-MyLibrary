import 'package:flutter/material.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reservations')),
      body: const Center(
        child: Text(
          'No reservations yet',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
