import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/reservation_service.dart';

class MyReservationsScreen extends StatelessWidget {
  MyReservationsScreen({super.key});

  final ReservationService _reservationService = ReservationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reservations')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reservationService.myReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No reservations yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(
                    'Book ID: ${data['bookId']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Status: ${data['status']}'),
                  trailing: data['status'] == 'active'
                      ? ElevatedButton(
                          onPressed: () async {
                            try {
                              await _reservationService.returnBook(
                                reservationId: reservations[index].id,
                                bookId: data['bookId'],
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Book returned successfully'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: const Text('Return'),
                        )
                      : const Text(
                          'Returned',
                          style: TextStyle(color: Colors.grey),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
