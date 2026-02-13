import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/reservation_service.dart';
import '../models/reservation_model.dart';

class MyReservationsScreen extends StatefulWidget {
  MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  final ReservationService _reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    // Expire stale reservations when the screen is loaded
    _reservationService.expireStaleReservations();
  }

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
                  trailing: _buildActionButton(context, reservation),
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
    // Issued → student can request return
    if (reservation.status == ReservationStatus.issued) {
      return ElevatedButton(
        onPressed: () async {
          await _reservationService.requestReturn(
            reservationId: reservation.id,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Return request sent to admin'),
            ),
          );
        },
        child: const Text('Request Return'),
      );
    }

    // Waiting admin
    if (reservation.status == ReservationStatus.returnRequested) {
      return const Text(
        'Waiting for approval',
        style: TextStyle(color: Colors.orange),
      );
    }

    // Reserved but not issued
    if (reservation.status == ReservationStatus.reserved) {
      return const Text(
        'Reserved (collect within 24h)',
        style: TextStyle(color: Colors.blue),
      );
    }

    // Expired
    if (reservation.status == ReservationStatus.expired) {
      return const Text(
        'Reservation expired',
        style: TextStyle(color: Colors.red),
      );
    }

    // Completed
    return const Text(
      'Completed',
      style: TextStyle(color: Colors.grey),
    );
  }
}
