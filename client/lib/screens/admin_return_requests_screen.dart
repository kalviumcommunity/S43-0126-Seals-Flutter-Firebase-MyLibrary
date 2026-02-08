import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation_model.dart';
import '../services/reservation_service.dart';

class AdminReturnRequestsScreen extends StatelessWidget {
  const AdminReturnRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReservationService reservationService = ReservationService();

    return Scaffold(
      appBar: AppBar(title: const Text('Return Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('status', isEqualTo: 'returnRequested')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No return requests'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              try {
                final reservation = Reservation.fromFirestore(docs[index]);

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.assignment_return),
                    title: Text(reservation.bookTitle),
                    subtitle: Text('User: ${reservation.userId}'),
                    trailing: ElevatedButton(
                      child: const Text('Approve'),
                      onPressed: () async {
                        await reservationService.approveReturn(
                          reservationId: reservation.id,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Return approved'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } catch (e) {
                // Skip invalid reservation instead of crashing admin UI
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
