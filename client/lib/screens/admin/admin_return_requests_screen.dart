import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/reservation_model.dart';
import '../../services/reservation_service.dart';

class AdminReturnRequestsScreen extends StatefulWidget {
  const AdminReturnRequestsScreen({super.key});

  @override
  State<AdminReturnRequestsScreen> createState() => _AdminReturnRequestsScreenState();
}

class _AdminReturnRequestsScreenState extends State<AdminReturnRequestsScreen> {
  final ReservationService reservationService = ReservationService();

  @override
  Widget build(BuildContext context) {
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
                      child: const Text('Approve Return'),
                      onPressed: () async {
                        await reservationService.approveReturn(
                          reservationId: reservation.id,
                        );

                        if (!context.mounted) return;
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
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
