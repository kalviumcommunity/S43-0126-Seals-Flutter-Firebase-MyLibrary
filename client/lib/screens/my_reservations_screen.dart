import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/reservation_service.dart';
import '../models/reservation_model.dart';

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

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final reservation = Reservation.fromFirestore(
                docs[index] as DocumentSnapshot<Map<String, dynamic>>,
              );

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(
                    reservation.bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Status: ${reservation.status.name}',
                  ),
                  trailing: _buildActionButton(
                    context,
                    reservation,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    Reservation reservation,
  ) {
    if (reservation.status == ReservationStatus.active) {
      return ElevatedButton(
        onPressed: () async {
          try {
            await _reservationService.requestReturn(
              reservationId: reservation.id,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Return request sent to admin'),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: const Text('Request Return'),
      );
    }

    if (reservation.status == ReservationStatus.returnRequested) {
      return const Text(
        'Waiting for approval',
        style: TextStyle(color: Colors.orange),
      );
    }

    return const Text(
      'Completed',
      style: TextStyle(color: Colors.grey),
    );
  }
}
